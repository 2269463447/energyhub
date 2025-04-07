//
//  EHUserInfoPasswordViewController.m
//  EnergyHub
//
//  Created by fanzhou on 2017/9/10.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHUserInfoPasswordViewController.h"
#import "EHHomeService.h"

@interface EHUserInfoPasswordViewController ()

@property (nonatomic, weak) UITextField *pwdTextField;
@property (nonatomic, weak) UITextField *nPwdTextField;
@property (nonatomic, weak) UITextField *surePwdTextField;

@property (nonatomic, strong) EHHomeService *service;

@end

@implementation EHUserInfoPasswordViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // 加载UI
    [self setupUI];
}

#pragma mark - Private Methods

- (void) setupUI {
    self.title = @"修改密码";
    self.view.backgroundColor = kBackgroundColor;
    CGFloat textFieldW = kScreenWidth - 40, textFieldH = 40.f;
    CGFloat textFieldX = 20.f;
    // 旧密码
    UITextField *pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, 5, textFieldW, textFieldH)];
    pwdTextField.backgroundColor = kBackgroundColor;
    pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTextField.secureTextEntry = YES;
    UIView *leftContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *oLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    oLeftView.image = [UIImage imageNamed:@"pwd_old"];
    oLeftView.contentMode = UIViewContentModeScaleAspectFit;
    oLeftView.frame = CGRectMake(0, 0, 20, 20);
    [leftContainer addSubview:oLeftView];
    pwdTextField.leftView = leftContainer;
    pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    pwdTextField.tintColor = [UIColor grayColor];
    pwdTextField.placeholder = @"旧密码";
    pwdTextField.font = [UIFont systemFontOfSize:17];
    self.pwdTextField = pwdTextField;
    UIView *pwdLineView = [[UIView alloc] initWithFrame:CGRectMake(textFieldX, pwdTextField.bottom, textFieldW, 1)];
    pwdLineView.backgroundColor = RGBColor(230, 230, 230);
    // 新密码
    UITextField *newPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, pwdLineView.bottom, textFieldW, textFieldH)];
    newPwdTextField.backgroundColor = kBackgroundColor;
    newPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    newPwdTextField.secureTextEntry = YES;
    UIView *codeContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *nLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inviteCode"]];
    nLeftView.frame = CGRectMake(0, 0, 20, 20);
    [codeContainer addSubview:nLeftView];
    newPwdTextField.leftView = codeContainer;
    newPwdTextField.leftViewMode = UITextFieldViewModeAlways;
    newPwdTextField.tintColor = [UIColor grayColor];
    newPwdTextField.placeholder = @"新密码";
    newPwdTextField.font = [UIFont systemFontOfSize:17];
    self.nPwdTextField = newPwdTextField;
    UIView *newPwdLineView = [[UIView alloc] initWithFrame:CGRectMake(textFieldX, newPwdTextField.bottom, textFieldW, 1)];
    newPwdLineView.backgroundColor = RGBColor(230, 230, 230);
    // 新密码确认
    UITextField *surePwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, newPwdLineView.bottom, textFieldW, textFieldH)];
    surePwdTextField.backgroundColor = kBackgroundColor;
    surePwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    surePwdTextField.secureTextEntry = YES;
    UIImageView *sLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_psd"]];
    sLeftView.frame = CGRectMake(0, 0, 20, 20);
    UIView *psdContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [psdContainer addSubview:sLeftView];
    surePwdTextField.leftView = psdContainer;
    surePwdTextField.leftViewMode = UITextFieldViewModeAlways;
    surePwdTextField.tintColor = [UIColor grayColor];
    surePwdTextField.placeholder = @"新密码确认";
    surePwdTextField.font = [UIFont systemFontOfSize:17];
    self.surePwdTextField = surePwdTextField;
    UIView *surePwdLineView = [[UIView alloc] initWithFrame:CGRectMake(textFieldX, surePwdTextField.bottom, textFieldW, 1)];
    surePwdLineView.backgroundColor = RGBColor(230, 230, 230);
    // 确定
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(20, surePwdLineView.bottom + 60, kScreenWidth - 40, 40);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [sureButton setBackgroundColor:RGBColor(255, 115, 0)];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pwdTextField];
    [self.view addSubview:pwdLineView];
    [self.view addSubview:newPwdTextField];
    [self.view addSubview:newPwdLineView];
    [self.view addSubview:surePwdTextField];
    [self.view addSubview:surePwdLineView];
    [self.view addSubview:sureButton];
}

#pragma mark - Custom Method

- (void)sureButtonClick {
    
    [self.view endEditing:YES];
    // 合法性检验
    if (self.pwdTextField.text.length == 0 || self.nPwdTextField.text.length == 0 || self.surePwdTextField.text.length == 0) {
        [MBProgressHUD showError:@"您还有未填写的信息" toView:self.view];
        return;
    }
    
    if ([self.nPwdTextField.text isEqualToString:self.surePwdTextField.text] == NO) {
        [MBProgressHUD showError:@"两次输入的新密码不一致" toView:self.view];
        return;
    }
    
    DefineWeakSelf
    NSDictionary *param = @{@"id":[EHUserInfo sharedUserInfo].Id,
                            @"pwd":self.pwdTextField.text,
                            @"pwd2":self.nPwdTextField.text,
                            };
    [self.service modifyPwdWithParam:param successBlock:^(NSString *message) {
        if (message == nil) {
            [MBProgressHUD showSuccess:@"修改成功" toView:weakSelf.view];
            [weakSelf.nPwdTextField resignFirstResponder];
            [weakSelf.surePwdTextField resignFirstResponder];
            [weakSelf.pwdTextField resignFirstResponder];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
                [[EHUserInfo sharedUserInfo] logOut];
                [[NSNotificationCenter defaultCenter] postNotificationName:ModifyPasswordSuccessNotification object:nil];
            });
        }else {
            [MBProgressHUD showError:message toView:weakSelf.view];
        }
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

#pragma mark - Getter

- (EHHomeService *)service
{
    if (!_service) {
        _service = [[EHHomeService alloc] init];
    }
    return _service;
}

@end
