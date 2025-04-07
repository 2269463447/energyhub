//
//  EHBeShareholderViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/13.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHBeShareholderViewController.h"
#import "EHBusinessServer.h"
#import "UIImage+Color.h"
#import "ReactiveObjC.h"
#import "FSTextView.h"
#import "UIViewController+Share.h"

@interface EHBeShareholderViewController ()<UITextViewDelegate, UITextFieldDelegate>

/**
 投资意向详情
 */
@property (weak, nonatomic) IBOutlet FSTextView *intentionTextView;

/**
 投资金额
 */
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

/**
 股份
 */
@property (weak, nonatomic) IBOutlet UITextField *stockTextField;

/**
 手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

/**
 提交
 */
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) EHBusinessServer *server;

@end

@implementation EHBeShareholderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
//    [self buttonIsCanClick];
}

- (void)config {
    self.view.backgroundColor = kBackgroundColor;
    self.intentionTextView.layer.borderWidth = 0.5;
    self.intentionTextView.layer.borderColor = RGBColor(205, 205, 205).CGColor;
    self.intentionTextView.layer.cornerRadius = 3;
    self.intentionTextView.placeholder = @"简述投资意向详情...";
    
    [self.continueButton setBackgroundImage:[UIImage createImageWithColor:EHMainColor] forState:UIControlStateNormal];
    [self.continueButton setBackgroundImage:[UIImage createImageWithColor:EHCommitBtnUnableColor] forState:UIControlStateDisabled];
    
    self.intentionTextView.delegate = self;
    self.moneyTextField.delegate = self;
    self.stockTextField.delegate = self;
    self.phoneTextField.delegate = self;

    [self facilitateShare];
}

#pragma mark -- Getter

- (EHBusinessServer *)server {
    if (!_server) {
        _server = [[EHBusinessServer alloc] init];
    }
    return _server;
}


- (IBAction)continueButtonAction:(id)sender {
    
    if (self.intentionTextView.text.length == 0) {
        [MBProgressHUD showError:@"请输入投资意向详情" toView:self.view];
        return;
    }
    if (self.moneyTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入投资金额" toView:self.view];
        return;
    }
    if (self.stockTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入期望股份" toView:self.view];
        return;
    }
    if (self.phoneTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入联系方式" toView:self.view];
        return;
    }
    
    if (![Utils validateMobile:self.phoneTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的联系方式" toView:self.view];
        return;
    }

    
    
    [MBProgressHUD showLoading:@"正在提交" toView:self.view];
    NSDictionary * dict = @{@"description":self.intentionTextView.text,
                            @"amount":self.moneyTextField.text,
                            @"shares":self.stockTextField.text,
                            @"contact":self.phoneTextField.text};
    DefineWeakSelf
    [self.server businessAddCompanyDataWithParam:dict successBlock:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString * status = [obj objectForKey:@"code"];
        if ([status isEqualToString:@"000000"]) {
            [MBProgressHUD showSuccess:@"提交成功，我们会在七个工作日内回复您" toView:self.view];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
//            self.intentionTextView.text = @"";
//            self.moneyTextField.text = @"";
//            self.stockTextField.text = @"";
//            self.phoneTextField.text = @"";
        }
        
    } errorBlock:^(EHError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

#pragma mark -- UITextViewDelegate --

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.layer.borderColor = EHMainColor.CGColor;
    textView.layer.borderWidth = 2;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    textView.layer.borderColor = EHLineColor.CGColor;
    textView.layer.borderWidth = 1;
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.layer.borderColor = EHMainColor.CGColor;
    textField.layer.borderWidth = 2;
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    textField.layer.borderColor = EHLineColor.CGColor;
    textField.layer.borderWidth = 1;
    return YES;

}          // return YES to allow editing to


- (void)buttonIsCanClick {

    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.intentionTextView.rac_textSignal, self.phoneTextField.rac_textSignal, self.moneyTextField.rac_textSignal, self.stockTextField.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        return @([value[0] length] > 0 && [value[1] length] > 0 && [value[2] length] > 0 && [value[3] length] > 0);
    }];
    
    self.continueButton.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
