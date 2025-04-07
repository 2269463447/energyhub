//
//  EHLoginViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/22.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHLoginViewController.h"
#import "EHRegiserViewController.h"
#import <ReactiveObjC.h>
#import "UIImage+Color.h"
#import "EHMineService.h"
#import "EHUserInfo.h"
#import "EHForgetPWDTableViewController.h"
#import "EHFastRegisterViewController.h"
#import "UIBarButtonItem+Extension.h"

@interface EHLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) EHMineService *netService;
@property (weak, nonatomic) IBOutlet UIButton *tmpUserLoginBtn;


@end

@implementation EHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    EHLog(@"viewcontrollers count - %@", @(self.navigationController.viewControllers.count));
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"ad_close"] target:self action:@selector(close)];
    }
    [self isShowTmpUsetLoginButton];
}

- (void)isShowTmpUsetLoginButton {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *tmpIsShow = [ud objectForKey:@"tmpIsShow"];
    if ([tmpIsShow isEqualToString:@"yes"]) {
        self.tmpUserLoginBtn.hidden = NO;
        NSString *account = [ud objectForKey:@"tmpAccount"];
        NSString *pwd = [ud objectForKey:@"tmpPwd"];
    }else {
        self.tmpUserLoginBtn.hidden = YES;
    }
}

- (void)configLoginButton {
    
    [self.loginButton setBackgroundImage:[UIImage createImageWithColor:EHMainColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#999999"]] forState:UIControlStateDisabled];
    
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.accountTextField.rac_textSignal, self.passwordTextField.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        return @([value[0] length] > 0 && [value[1] length] > 0);
    }];
    
    self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}

#pragma mark -- Button Event

- (IBAction)loginAction:(id)sender {
    
    if (self.accountTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入账号" toView:self.view];
        return;
    }
    
    
    if (self.passwordTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }

    NSDictionary * dic = @{@"userName": self.accountTextField.text,
                           @"pwd": self.passwordTextField.text};
    
    [self.netService loginDataWithParam:dic successBlock:^(EHUserInfo *userInfo) {
        
        //[[EHUserInfo sharedUserInfo] setData:obj];
        [EHUserInfo loginWithData:userInfo];
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        }

    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:self.view];
    }];
}

- (IBAction)registerAction:(id)sender {
    EHFastRegisterViewController * regiserVC = [[EHFastRegisterViewController alloc] init];
    regiserVC.title = @"注册";
    [self.navigationController pushViewController:regiserVC animated:YES];
}

- (IBAction)forgetPasswordAction:(id)sender {
    EHForgetPWDTableViewController *forgetVC = [[EHForgetPWDTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    forgetVC.title = @"找回密码";
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)close {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -- Getter

- (EHMineService *)netService {
    if (!_netService) {
        _netService = [[EHMineService alloc] init];
    }
    return _netService;
}

- (IBAction)changeSecretKey:(UIButton *)sender {
    if ([sender.currentImage isEqual:[UIImage imageNamed:@"close_eyes"]]) {
        [sender setImage:[UIImage imageNamed:@"eyes"] forState:UIControlStateNormal];
        self.passwordTextField.secureTextEntry = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"close_eyes"] forState:UIControlStateNormal];
        self.passwordTextField.secureTextEntry = YES;
    }
}

- (IBAction)tmpUserLogin:(id)sender {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *tmpIsShow = [ud objectForKey:@"tmpIsShow"];
    if ([tmpIsShow isEqualToString:@"yes"]) {
        self.tmpUserLoginBtn.hidden = NO;
        NSString *account = [ud objectForKey:@"tmpAccount"];
        NSString *pwd = [ud objectForKey:@"tmpPwd"];
        self.accountTextField.text = account;
        self.passwordTextField.text = pwd;
        [self loginAction:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
