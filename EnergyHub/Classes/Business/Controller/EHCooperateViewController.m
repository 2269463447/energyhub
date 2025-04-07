//
//  EHCooperateViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/13.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHCooperateViewController.h"
#import "FSTextView.h"
#import <ReactiveObjC.h>
#import "UIImage+Color.h"
#import "EHBusinessServer.h"

@interface EHCooperateViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet FSTextView *intentionTextView;
@property (weak, nonatomic) IBOutlet FSTextView *companyTextView;
@property (weak, nonatomic) IBOutlet FSTextView *contactTextView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet FSTextView *addressTextView;
@property (strong, nonatomic) EHBusinessServer *server;
@end

@implementation EHCooperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTextView];
//    [self buttonIsCanClick];
}

#pragma mark -- Getter

- (EHBusinessServer *)server {
    if (!_server) {
        _server = [[EHBusinessServer alloc] init];
    }
    return _server;
}

#pragma mark -- Config

- (void)configTextView {
    
    self.view.backgroundColor = kBackgroundColor;
    
    self.intentionTextView.delegate = self;
    self.companyTextView.delegate = self;
    self.contactTextView.delegate = self;
    self.addressTextView.delegate = self;

    self.intentionTextView.layer.borderWidth = 1;
    self.intentionTextView.layer.borderColor = EHLineColor.CGColor;
    self.intentionTextView.placeholder = @"与本站合作意向描述...";
    
    self.companyTextView.layer.borderWidth = 1;
    self.companyTextView.layer.borderColor = EHLineColor.CGColor;
    self.companyTextView.placeholder = @"单位名称填写...";

    self.contactTextView.layer.borderWidth = 1;
    self.contactTextView.layer.borderColor = EHLineColor.CGColor;
    self.contactTextView.placeholder = @"单位联系方式填写...";

    self.addressTextView.layer.borderWidth = 1;
    self.addressTextView.layer.borderColor = EHLineColor.CGColor;
    self.addressTextView.placeholder = @"单位地址填写...";

}

- (void)buttonIsCanClick {
    
    [self.commitButton setBackgroundImage:[UIImage createImageWithColor:EHMainColor] forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:[UIImage createImageWithColor:EHCommitBtnUnableColor] forState:UIControlStateDisabled];

    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.intentionTextView.rac_textSignal, self.companyTextView.rac_textSignal, self.contactTextView.rac_textSignal, self.addressTextView.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        return @([value[0] length] > 0 && [value[1] length] > 0 && [value[2] length] > 0 && [value[3] length] > 0);
    }];
    
    self.commitButton.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}

#pragma mark -- Button Event

- (IBAction)commitAction:(id)sender {
    
    if (self.intentionTextView.text.length == 0) {
        [MBProgressHUD showError:@"请输入合作意向" toView:self.view];
        return;
    }
    
    if (self.companyTextView.text.length == 0) {
        [MBProgressHUD showError:@"请输入单位名称" toView:self.view];
        return;
    }
    
    if (self.contactTextView.text.length == 0) {
        [MBProgressHUD showError:@"请输入联系方式" toView:self.view];
        return;
    }

    if (self.addressTextView.text.length == 0) {
        [MBProgressHUD showError:@"请输入单位地址" toView:self.view];
        return;
    }

    
    if (![Utils validateMobile:self.contactTextView.text]) {
        [MBProgressHUD showError:@"请输入正确联系方式" toView:self.view];
        return;
    }

    
    [MBProgressHUD showLoading:@"正在提交.." toView:self.view];
    
    NSDictionary * dic = @{@"comment": self.intentionTextView.text,
                           @"companyName": self.companyTextView.text,
                           @"companyContact":self.contactTextView.text,
                           @"companyAddr":self.addressTextView.text};
    [self.server businessAddCooperateDataWithParam:dic successBlock:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString * code = [obj objectForKey:@"code"];
        if ([code isEqualToString:kRightCode]) {
            self.intentionTextView.text = nil;
            self.addressTextView.text = nil;
            self.contactTextView.text = nil;
            self.companyTextView.text = nil;
            [MBProgressHUD showSuccess:@"提交成功，我们会在7个工作日内练习您！" toView:self.view];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
