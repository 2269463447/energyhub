//
//  EHBuySingleClassViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/10/3.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBuySingleClassViewController.h"
#import "EHHomeService.h"
#import "EHVidoMenuItem.h"
#import "NSString+EHMoney.h"
//#import "EHPayManagner.h"
#import "EHLoginViewController.h"

@interface EHBuySingleClassViewController ()

@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) EHHomeService *homeService;

@end

@implementation EHBuySingleClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"支付";
    self.view.backgroundColor = kBackgroundColor;
    // 左上角
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    //[backButton sizeToFit];
    // 这句代码放在sizeToFit后面
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.payBtn.backgroundColor = EHMainColor;
    // price
    CGFloat price = ceilf(_menuItem.price.floatValue * 1.3);
    self.priceLabel.text = [NSString stringWithFormat:@"%.0fU币", price];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payBtnAction:(id)sender {
    
    if (!IsLogin) {
        EHLoginViewController *login = [EHLoginViewController instance];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    // 余额不足
    CGFloat uMoney = ceilf(_menuItem.price.floatValue * 1.3); // 单节课涨30%
    if (![[EHUserInfo sharedUserInfo] isAffordable:uMoney]) {
        [MBProgressHUD showError:@"余额不足，请充值!" toView:self.view];
        return;
    }
    
    NSString *price = [NSString stringWithFormat:@"%.0f", uMoney];
    NSInteger userId = [[EHUserInfo sharedUserInfo].Id integerValue];
    NSDictionary *param = @{@"couId": _menuItem.ID, @"account": price, @"id": @(userId)};
    DefineWeakSelf
    [self.homeService payForOneWithParam:param successBlock:^(NSDictionary *code) {
        [MBProgressHUD showSuccess:@"支付成功！" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:BuyCourseSuccessNotification object:nil userInfo:@{@"data": weakSelf.menuItem}];
            // 支付成功, 返回
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:NULL];
        });
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

#pragma mark - Getter

- (EHHomeService *)homeService {
    if (!_homeService) {
        _homeService = [[EHHomeService alloc] init];
    }
    return _homeService;
}

#pragma mark - Memory

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
