//
//  EHFastRegisterViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/9/7.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHFastRegisterViewController.h"
#import "EHRegiserViewController.h"
#import "EHMineService.h"
#import <ReactiveObjC.h>
#import "UIImage+Color.h"
#import "EHRegisterProtocolView.h"

@interface EHFastRegisterViewController ()
{
    NSInteger _second;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *inviteTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectProtocolBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (nonatomic, strong) EHMineService *service;
@property (nonatomic, strong) NSTimer *codeTimer;
@property (nonatomic, strong) EHRegisterProtocolView *protocolView;
@end

@implementation EHFastRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    
    _second = 60;
    self.codeBtn.layer.borderWidth = 1;
    self.codeBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.codeBtn.layer.cornerRadius = 25/2;
    
//    [self.registerBtn setBackgroundImage:[UIImage createImageWithColor:EHMainColor] forState:UIControlStateNormal];
//    [self.registerBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#999999"]] forState:UIControlStateDisabled];
    
//    [self registerIsCanClick];
    
    [self.view addSubview:self.protocolView];
}

- (void)registerIsCanClick {
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.phoneTF.rac_textSignal, self.codeTF.rac_textSignal, self.passwordTF.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        return @([value[0] length] > 0 && [value[1] length] > 0 && [value[2] length] > 0);
    }];
    
    self.registerBtn.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}

#pragma mark -- Getter

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

- (EHRegisterProtocolView *)protocolView {
    if (!_protocolView) {
        _protocolView = [[[NSBundle mainBundle] loadNibNamed:@"EHRegisterProtocolView" owner:self options:nil] lastObject];
        _protocolView.hidden = YES;
        DefineWeakSelf
        _protocolView.agreeBlock = ^{
            weakSelf.protocolView.hidden = YES;
        };
    }
    return _protocolView;
}

#pragma mark -- Events

- (void)codeTimerAction {
    _second--;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds", _second] forState:UIControlStateNormal];
    if (_second == 0) {
        [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.codeBtn.enabled = YES;
        [self.codeTimer invalidate];
        _second = 60;
    }
}

/**
 获取验证码
 */
- (IBAction)clickGetCode:(UIButton *)sender {
    
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
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

/**
 注册
 */
- (IBAction)clickRegister:(id)sender {
    
    if (self.phoneTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }

    if (![Utils validateMobile:self.phoneTF.text]) {
        [MBProgressHUD showError:@"请输入正确手机号" toView:self.view];
        return;
    }
    
    if (self.codeTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }

    if (self.passwordTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    
    [MBProgressHUD showLoading:@"" toView:self.view];
    NSDictionary *param = @{@"phone":self.phoneTF.text,
                            @"code":self.codeTF.text,
                            @"pwd":self.passwordTF.text,
                            @"invitecode":self.inviteTF.text};
    
    DefineWeakSelf
    [self.service fastRegisterDataWithParam:param successBlock:^(id obj) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSString *code = [obj objectForKey:@"code"];
            if (![code isKindOfClass:[NSString class]]) {
                code = [NSString stringWithFormat:@"%@", code];
            }
            // base已处理
            // 这个接口要特殊处理，规则改成666666代表成功
            if ([code isEqualToString:@"666666"]) {
                code = EHSuccessCode;
            }
            if ([code isEqualToString:EHSuccessCode]) {
                NSDictionary * data = [obj objectForKey:@"data"];
                EHUserInfo *user = [EHUserInfo mj_objectWithKeyValues:data];
                [EHUserInfo loginWithData:user];
                [MBProgressHUD showSuccess:@"注册成功" toView:weakSelf.view];
                // 延时1秒再返回
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                });
            }else{
                NSString *errorMsg = [obj objectForKey:@"errorMsg"];
                [MBProgressHUD showError:errorMsg toView:weakSelf.view];
            }
        
    } errorBlock:^(EHError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

/**
 注册协议
 */
- (IBAction)clickRegisterProtocol:(UIButton *)sender {
    DefineWeakSelf
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.protocolView.hidden = NO;
    }];
}

/**
 注册协议
 */
- (IBAction)clickSelectProtocol:(UIButton *)sender {
    sender.selected = !sender.selected;
    DefineWeakSelf
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.protocolView.hidden = NO;
    }];
}

/**
 邮箱注册
 */
- (IBAction)clickGoNomalRegister:(id)sender {
    EHRegiserViewController * regiserVC = [[EHRegiserViewController alloc] init];
    regiserVC.title = @"注册";
    [self.navigationController pushViewController:regiserVC animated:YES];
}

- (void)dealloc {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
