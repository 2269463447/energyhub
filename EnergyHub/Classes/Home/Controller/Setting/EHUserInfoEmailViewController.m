//
//  EHUserInfoEmailViewController.m
//  EnergyHub
//
//  Created by fanzhou on 2017/9/10.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHUserInfoEmailViewController.h"
#import "EHHomeService.h"

@interface EHUserInfoEmailViewController ()

@property (nonatomic, weak) UITextField *emailTextField;
@property (nonatomic, weak) UITextField *nEmailTextField;

@property (nonatomic, strong) EHHomeService *service;

@end

@implementation EHUserInfoEmailViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // 加载UI
    [self setupUI];
}

#pragma mark - Private Methods

- (void) setupUI {
    self.title = @"修改邮箱";
    self.view.backgroundColor = kBackgroundColor;
    CGFloat textFieldW = kScreenWidth - 40, textFieldH = 44.f;
    CGFloat textFieldX = 20.f;
    // 旧邮箱
    UITextField *emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, 5, textFieldW, textFieldH)];
    emailTextField.backgroundColor = kBackgroundColor;
    emailTextField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"message"]];
    emailTextField.leftViewMode = UITextFieldViewModeAlways;
    emailTextField.tintColor = RGBColor(230, 230, 230);
    emailTextField.placeholder = @"旧邮箱";
    emailTextField.font = [UIFont systemFontOfSize:17];
    self.emailTextField = emailTextField;
    UIView *emailLineView = [[UIView alloc] initWithFrame:CGRectMake(textFieldX, emailTextField.bottom, textFieldW, 1)];
    emailLineView.backgroundColor = RGBColor(230, 230, 230);
    // 新邮箱
    UITextField *newEmailTextField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, emailLineView.bottom, textFieldW, textFieldH)];
    newEmailTextField.backgroundColor = kBackgroundColor;
    newEmailTextField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"message"]];
    newEmailTextField.leftViewMode = UITextFieldViewModeAlways;
    newEmailTextField.tintColor = RGBColor(230, 230, 230);
    newEmailTextField.placeholder = @"新邮箱";
    newEmailTextField.font = [UIFont systemFontOfSize:17];
    self.nEmailTextField = newEmailTextField;
    UIView *newEmailLineView = [[UIView alloc] initWithFrame:CGRectMake(textFieldX, newEmailTextField.bottom, textFieldW, 1)];
    newEmailLineView.backgroundColor = RGBColor(230, 230, 230);
    // 确定
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(20, newEmailLineView.bottom + 50, kScreenWidth - 40, 40);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [sureButton setBackgroundColor:RGBColor(255, 115, 0)];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emailTextField];
    [self.view addSubview:emailLineView];
    [self.view addSubview:newEmailTextField];
    [self.view addSubview:newEmailLineView];
    [self.view addSubview:sureButton];
}

#pragma mark - Custom Method

- (void)sureButtonClick {
    
    [self.view endEditing:YES];
    // 合法性检验
    if (self.emailTextField.text.length == 0 || self.nEmailTextField.text.length == 0) {
        [MBProgressHUD showError:@"您还有未填写的信息" toView:self.view];
        return;
    }
    if ([Utils validateEmail:self.emailTextField.text] == NO || [Utils validateEmail:self.nEmailTextField.text] == NO) {
        [MBProgressHUD showError:@"请输入正确的邮箱" toView:self.view];
        return;
    }
    
    DefineWeakSelf
    NSDictionary *param = @{@"id":[EHUserInfo sharedUserInfo].Id,
                            @"email":self.emailTextField.text,
                            @"email2":self.nEmailTextField.text
                            };
    [self.service modifyEmailWithParam:param successBlock:^(NSString *message) {
        if (message == nil) {
            [MBProgressHUD showSuccess:@"修改成功" toView:weakSelf.view];
            [weakSelf.emailTextField resignFirstResponder];
            [weakSelf.nEmailTextField resignFirstResponder];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
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
