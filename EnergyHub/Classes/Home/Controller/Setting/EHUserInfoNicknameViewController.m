//
//  EHUserInfoNicknameViewController.m
//  EnergyHub
//
//  Created by fanzhou on 2017/9/10.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHUserInfoNicknameViewController.h"
#import "EHHomeService.h"
#import "FSTextView.h"

@interface EHUserInfoNicknameViewController ()

@property (nonatomic, weak) FSTextView *textView;

@property (nonatomic, strong) EHHomeService *service;

@end

@implementation EHUserInfoNicknameViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // 加载UI
    [self setupUI];
}

#pragma mark - Private Methods

- (void) setupUI {
    self.title = @"昵称";
    self.view.backgroundColor = kBackgroundColor;
    // personalSign
    FSTextView *textView = [FSTextView textView];
//    textView.backgroundColor = [UIColor whiteColor];
    textView.tintColor = [UIColor grayColor];
    textView.frame = CGRectMake(10, 30, kScreenWidth - 20, 44);
    textView.borderColor = RGBColor(255, 115, 0);
    textView.borderWidth = 3.f;
    textView.layer.cornerRadius = 1.f;
    textView.layer.masksToBounds = YES;
    textView.text = [EHUserInfo sharedUserInfo].nickName;
    self.textView = textView;
    // 确定
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(20, textView.bottom + 30, kScreenWidth - 40, 40);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [sureButton setBackgroundColor:RGBColor(255, 115, 0)];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textView];
    [self.view addSubview:sureButton];
}

#pragma mark - Custom Method

- (void)sureButtonClick {
    [self.view endEditing:YES];
    // 合法性检验
    if (self.textView.formatText.length == 0) {
        [MBProgressHUD showError:@"请填写昵称" toView:self.view];
        return;
    }
    DefineWeakSelf
    NSString *nickname = self.textView.formatText;
    NSDictionary *param = @{@"niceName": nickname};
    [self.service modifyNicknameWithParam:param successBlock:^(NSString *message) {
        if (message == nil) {
            [MBProgressHUD showSuccess:@"修改成功" toView:weakSelf.view];
            [weakSelf.textView resignFirstResponder];
            [EHUserInfo sharedUserInfo].nickName = weakSelf.textView.formatText;
            [EHUserInfo updateUserData];
            // 借用头像更新的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:AvatarUpdatedNotification object:nil userInfo:@{@"nickname": nickname}];
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
