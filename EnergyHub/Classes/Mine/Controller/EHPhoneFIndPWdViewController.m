//
//  EHPhoneFIndPWdViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/9/16.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHPhoneFIndPWdViewController.h"
#import "UIImage+Color.h"
#import <ReactiveObjC.h>
#import "EHMineService.h"
#import "EHLoginViewController.h"

@interface EHPhoneFIndPWdViewController ()
{
    NSInteger _second;
}
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (strong, nonatomic) EHMineService *service;
@property (nonatomic, strong) NSTimer *codeTimer;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@end

@implementation EHPhoneFIndPWdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
//    [self buttonIsCanClick];
}

- (void)setupUI {
    _second = 60;
    self.codeBtn.layer.borderWidth = 1;
    self.codeBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.codeBtn.layer.cornerRadius = 25/2;
}

/*
- (void)buttonIsCanClick {
    
    [self.enterBtn setBackgroundImage:[UIImage createImageWithColor:EHMainColor] forState:UIControlStateNormal];
    [self.enterBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#999999"]] forState:UIControlStateDisabled];
    
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.phoneTF.rac_textSignal, self.codeTF.rac_textSignal, self.pwdTF.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        return @([value[0] length] > 0 && [value[1] length] > 0 && [value[2] length] > 0);
    }];
    
    self.enterBtn.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}
 */

- (EHMineService *)service {
    if (!_service) {
        _service = [[EHMineService alloc] init];
    }
    return _service;
}

- (NSTimer *)codeTimer {
    if (!_codeTimer) {
        _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(codeTimerAction) userInfo:nil repeats:YES];
    }
    return _codeTimer;
}

- (void)codeTimerAction {
    _second--;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ld", _second] forState:UIControlStateNormal];
    if (_second == 0) {
        [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.codeBtn.enabled = YES;
        [self.codeTimer invalidate];
        _second = 60;
    }
}

- (IBAction)codeBtnAction:(id)sender {
    
    if (![Utils validateMobile:self.phoneTF.text]) {
        [MBProgressHUD showError:@"请输入正确手机号" toView:self.view];
        return;
    }
    
    DefineWeakSelf
    [self.service verificationCodeDataWithParam:@{@"phone":self.phoneTF.text} successBlock:^(id obj) {
        NSString * code = [obj objectForKey:@"code"];
        if ([code isEqualToString:EHSuccessCode]) {
            [weakSelf.codeTimer fire];
            weakSelf.codeBtn.enabled = NO;
        }
        
    } errorBlock:^(EHError *error) {
        
    }];
}


- (IBAction)enterBtnAction:(id)sender {
    
    if (self.phoneTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }
    
    if (![Utils validateMobile:self.phoneTF.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号" toView:self.view];
        return;
    }
    
    if (self.codeTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }
    
    if (self.pwdTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    
    if (self.pwdTF.text.length < 6) {
        [MBProgressHUD showError:@"密码至少6位" toView:self.view];
        return;
    }
    
    NSDictionary *param = @{@"phone":self.phoneTF.text,
                            @"code":self.codeTF.text,
                            @"pwd":self.pwdTF.text};
    
    DefineWeakSelf
    [self.service phoneFindPWdParam:param successBlock:^(NSDictionary *dic) {
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:EHSuccessCode]) {
            [MBProgressHUD showSuccess:@"修改成功" toView:weakSelf.view];            
            // 延时0.8秒再返回（显示提示框）
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.navigationController.viewControllers.count > 2) {
                    UIViewController *loginVC = weakSelf.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:loginVC animated:YES];
                }else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            });
            
        }else{
            NSString *errorMsg = dic[@"errorMsg"];
            [MBProgressHUD showError:errorMsg toView:weakSelf.view];
        }

    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
