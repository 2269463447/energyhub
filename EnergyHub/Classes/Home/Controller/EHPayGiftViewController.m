//
//  EHPayGiftViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/19.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHPayGiftViewController.h"
#import "EHHomeService.h"
//#import "EHPayManagner.h"
#import "UIBarButtonItem+Extension.h"
#import "EHLoginViewController.h"

@interface EHPayGiftViewController ()

@property (nonatomic, strong) EHHomeService *homeService;

@end

@implementation EHPayGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打赏";
    self.view.backgroundColor = kBackgroundColor;
    CGFloat y = 10.f;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, y, kScreenWidth, 40)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = EHFontColor;
    titleLabel.text = @"打赏金额：";
    [self.view addSubview:titleLabel];
    y = titleLabel.bottom + 5;
    UILabel *valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, 40)];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.font = [UIFont boldSystemFontOfSize:18];
    valueLabel.text = [NSString stringWithFormat:@"%.0fU币", self.giftValue * 1.0f];
    [self.view addSubview:valueLabel];
    y = valueLabel.bottom;
    /*
    UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, y, kScreenWidth, 30)];
    payLabel.textAlignment = NSTextAlignmentLeft;
    payLabel.font = [UIFont systemFontOfSize:14];
    payLabel.text = @"选择支付方式：";
    [self.view addSubview:payLabel];
    y = payLabel.bottom + 5;*/
    UIButton *alipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alipayBtn.tag = 100;
    alipayBtn.backgroundColor = EHMainColor;
    alipayBtn.frame = CGRectMake(15, y + 20, kScreenWidth - 30, 40);
    [alipayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alipayBtn setTitle:@"确定打赏" forState:UIControlStateNormal];
    [alipayBtn addTarget:self action:@selector(payGift:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alipayBtn];
    /*
    y = alipayBtn.bottom + 10;
    UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wxBtn.tag = 101;
    wxBtn.backgroundColor = RGBColor(21, 153, 50);
    wxBtn.frame = CGRectMake(15, y, kScreenWidth - 30, 40);
    [wxBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wxBtn setTitle:@"微信支付" forState:UIControlStateNormal];
    [wxBtn addTarget:self action:@selector(payGift:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wxBtn];*/
    // barItem
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"back"] target:self action:@selector(backAction)];
}

- (void)backAction {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)payGift:(UIButton *)sender {
    
    if (![Utils isReachable]) {
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
        return;
    }
    // 登录后才能打赏
    if (![EHUserInfo sharedUserInfo].isLogin) {
        //        [MBProgressHUD showError:@"请先登录" toView:self.view];
        EHLoginViewController *login = [EHLoginViewController instance];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    // 余额不足
    if (![[EHUserInfo sharedUserInfo] isAffordable:_giftValue]) {
        [MBProgressHUD showError:@"余额不足，请充值!" toView:self.view];
        return;
    }
    
    NSInteger cid = [_courseId integerValue];
    NSDictionary *param = @{@"id": @(cid), @"money": @(_giftValue),
                            @"uuid": [EHUserInfo sharedUserInfo].uuid
                            };
    DefineWeakSelf
    [self.homeService payForGiftWithParam:param successBlock:^(NSDictionary *code) {
        // 支付成功, 返回
        [MBProgressHUD showSuccess:@"打赏成功！" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 支付成功, 返回
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:NULL];
        });
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
    /*
    PayMethod payMethod = PayMethodWeixin;
    
    if (sender.tag == 100) {
        payMethod = PayMethodAlipay;
    }
    if (!self.courseId || !self.giftValue) {
        [MBProgressHUD showError:@"数据有误！" toView:self.view];
        return;
    }
    
    NSString *body = @"打赏服务";
    NSString *courseId = self.courseId;
    NSInteger recharge = self.giftValue;
    
    DefineWeakSelf
    
    [MBProgressHUD showLoading:@"正在获取支付信息..." toView:self.view];
    if (payMethod == PayMethodWeixin) {
        
        NSDictionary *params = @{@"w": @2, @"recharge": @(recharge * 100),
                                 @"body": body, @"attach": courseId};
        [self.homeService wxpayOrderWithParam:params successBlock:^(NSDictionary *orderInfo) {
            [self payWithMethod:payMethod order:orderInfo];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } errorBlock:^(EHError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [MBProgressHUD showError:error.msg toView:weakSelf.view];
        }];
    }else if (payMethod == PayMethodAlipay) {
        NSDictionary *params = @{@"q": @1, @"w": @2, @"recharge": @(recharge),
                                 @"body": body, @"passbackParams": courseId};
        
        [self.homeService alipayOrderWithParam:params successBlock:^(NSString *orderInfo) {
            [self payWithMethod:payMethod order:orderInfo];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } errorBlock:^(EHError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [MBProgressHUD showError:error.msg toView:weakSelf.view];
        }];
    }*/
}

//废弃
- (void)payWithMethod:(PayMethod)payMethod order:(id)orderInfo {
    /*
    // 购买
    DefineWeakSelf
    
    [[EHPayManagner sharedManager] payWithPayMethod:payMethod orderInfo:orderInfo completionBlock:^(BOOL success, NSString *message) {
        if (success) {
            [MBProgressHUD showSuccess:@"打赏成功！" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 支付成功, 返回
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:NULL];
            });
        }else {
            [MBProgressHUD showError:message toView:self.view];
        }
    }];*/
}

#pragma mark - Getter

- (EHHomeService *)homeService {
    if (!_homeService) {
        _homeService = [[EHHomeService alloc]init];
    }
    return _homeService;
}

@end
