//
//  EHUserInfoPersonalSignViewController.m
//  EnergyHub
//
//  Created by fanzhou on 2017/9/10.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHUserInfoPersonalSignViewController.h"
#import "FSTextView.h"
#import "EHHomeService.h"

@interface EHUserInfoPersonalSignViewController ()

@property (nonatomic, weak) FSTextView *textView;
@property (nonatomic, strong) EHHomeService *service;

@end

@implementation EHUserInfoPersonalSignViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // 加载UI
    [self setupUI];
}

#pragma mark - Private Methods

- (void) setupUI {
    self.title = @"个性签名";
    self.view.backgroundColor = kBackgroundColor;
    // personalSign
    FSTextView *textView = [FSTextView textView];
//    textView.backgroundColor = [UIColor whiteColor];
    textView.frame = CGRectMake(10, 30, kScreenWidth - 20, 120);
    textView.placeholderFont = [UIFont systemFontOfSize:15];
    textView.placeholderColor = [UIColor grayColor];
    textView.placeholder = @"编辑个性签名......";
    textView.borderColor = RGBColor(255, 115, 0);
    textView.borderWidth = 3.f;
    textView.layer.cornerRadius = 1.f;
    textView.layer.masksToBounds = YES;
    self.textView = textView;
    // 确定
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(20, textView.bottom + 60, kScreenWidth - 40, 40);
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
    if (self.textView.formatText.length <= 0) {
        [MBProgressHUD showError:@"请填写个性签名" toView:self.view];
        return;
    }
    // 提交成功
    DefineWeakSelf
    [self.service modifySignatureWithParam:@{@"personSign": self.textView.formatText} successBlock:^(NSString *info) {
        [MBProgressHUD showSuccess:@"修改成功" toView:weakSelf.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
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
