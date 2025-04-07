//
//  EHApplyTeacherViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/31.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHApplyTeacherViewController.h"
#import "FSTextView.h"
#import "ReactiveObjC.h"
#import "UIImage+Color.h"
#import "EHMineService.h"

@interface EHApplyTeacherViewController ()

/**
 名字
 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

/**
 手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

/**
 邮箱
 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

/**
 擅长
 */
@property (weak, nonatomic) IBOutlet UITextField *specialtyTextField;

/**
 个人介绍
 */
@property (weak, nonatomic) IBOutlet FSTextView *introduceTextView;

/**
 提交
 */
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) EHMineService *applyService;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classBackgroundViewLayoutConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *contactImgView;
@property (weak, nonatomic) IBOutlet UIImageView *emailImgView;
@property (weak, nonatomic) IBOutlet UIImageView *classImaView;
@property (weak, nonatomic) IBOutlet UIImageView *introduceImgView;

@property (nonatomic, assign) EHApplyStyle style;

@end

@implementation EHApplyTeacherViewController

- (instancetype)initWithStyle:(EHApplyStyle)style {
    self = [super init];
    if (self) {
        self.style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self buttonIsCanClick];
    [self otherConfig];
}

- (void)otherConfig {
    if (self.style == EHShowClassStyle) {
        self.classBackgroundViewLayoutConstraint.constant = 0;
        self.specialtyTextField.hidden = YES;
        self.classImaView.hidden = YES;
        self.nameTextField.placeholder = @"课程名称";
        self.phoneTextField.placeholder = @"是否本站协助";
        self.emailTextField.placeholder = @"课程类别";
        self.phoneTextField.keyboardType = UIKeyboardTypeDefault;
        
        self.introduceTextView.placeholder = @"课程详情描述(适合人群、课程节数、主要特点)";
        self.introduceImgView.image = [UIImage imageNamed:@"describe_image"];
        self.contactImgView.image = [UIImage imageNamed:@"assist_image"];
        self.emailImgView.image = [UIImage imageNamed:@"category_image"];
    }else{
        self.introduceTextView.placeholder = @"个人介绍(100字以内)";
        self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
}

#pragma mark -- Getter

- (EHMineService *)applyService {
    if (!_applyService) {
        _applyService = [[EHMineService alloc] init];
    }
    return _applyService;
}


/*
- (void)buttonIsCanClick {
    [self.commitBtn setBackgroundImage:[UIImage createImageWithColor:EHMainColor] forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#999999"]] forState:UIControlStateDisabled];
    
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.nameTextField.rac_textSignal, self.phoneTextField.rac_textSignal, self.emailTextField.rac_textSignal, self.specialtyTextField.rac_textSignal, self.introduceTextView.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        return @([value[0] length] > 0 && [value[1] length] > 0 && [value[2] length] > 0 && [value[3] length] > 0 && [value[4] length] > 0 && [value[4] length] < 100);
    }];
    
    self.commitBtn.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}
 */

#pragma mark -- Event

- (IBAction)commitBtnAction:(id)sender {
    if (self.style == EHShowClassStyle) {
        [self commitReleaseClass];
    }else{
        [self commitApplyTeacher];
    }
}


/**
 上传申请老师信息
 */
- (void)commitApplyTeacher {
    
    if (self.nameTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写姓名" toView:self.view];
        return;
    }
    
    if (self.phoneTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写联系电话" toView:self.view];
        return;
    }

    if (self.emailTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写邮箱" toView:self.view];
        return;
    }

    if (self.emailTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写邮箱" toView:self.view];
        return;
    }

    if (self.emailTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写邮箱" toView:self.view];
        return;
    }

    if (self.specialtyTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写擅长课种" toView:self.view];
        return;
    }
    
    if (self.introduceTextView.text.length == 0) {
        [MBProgressHUD showError:@"请填写个人介绍" toView:self.view];
        return;
    }


    if (![Utils validateMobile:self.phoneTextField.text]) {
        [MBProgressHUD showError:@"请填写正确手机号" toView:self.view];
        return;
    }
    
    if (![Utils validateEmail:self.emailTextField.text]) {
        [MBProgressHUD showError:@"请填写正确邮箱" toView:self.view];
        return;
    }
    
    [MBProgressHUD showLoading:@"正在提交" toView:self.view];
    NSDictionary * dict = @{@"realName":self.nameTextField.text,
                            @"phone":self.phoneTextField.text,
                            @"email":self.emailTextField.text,
                            @"course":self.specialtyTextField.text,
                            @"introduction":self.introduceTextView.text,
                            @"id":[EHUserInfo sharedUserInfo].Id,
                            @"token":[EHUserInfo sharedUserInfo].token};
    
    DefineWeakSelf
    [self.applyService applyTeacherDataWithParam:dict successBlock:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
        [weakSelf.navigationController popViewControllerAnimated:YES];
//        self.nameTextField.text = @"";
//        self.emailTextField.text = @"";
//        self.phoneTextField.text = @"";
//        self.specialtyTextField.text = @"";
//        self.introduceTextView.text = @"";
    } errorBlock:^(EHError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/**
 提交申请课程信息
 */
- (void)commitReleaseClass {
    
    
    if (self.nameTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写课程姓名" toView:self.view];
        return;
    }
    
    if (self.phoneTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写确认需要本站协助" toView:self.view];
        return;
    }
    
    if (self.emailTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写课程类别" toView:self.view];
        return;
    }
    
    
    if (self.introduceTextView.text.length == 0) {
        [MBProgressHUD showError:@"请填写课程详情描述" toView:self.view];
        return;
    }
    
    
    [MBProgressHUD showLoading:@"正在提交" toView:self.view];
    NSDictionary * dict = @{@"courseName":self.nameTextField.text,
                            @"assist":self.phoneTextField.text,
                            @"courseType":self.emailTextField.text,
                    @"courseDescribe":self.introduceTextView.text,
                            @"id":[EHUserInfo sharedUserInfo].Id
                            };
    
    DefineWeakSelf
    [self.applyService releaseClassDataWithParam:dict successBlock:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
        [weakSelf.navigationController popViewControllerAnimated:YES];

//        self.nameTextField.text = @"";
//        self.emailTextField.text = @"";
//        self.phoneTextField.text = @"";
//        self.specialtyTextField.text = @"";
//        self.introduceTextView.text = @"";
    } errorBlock:^(EHError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:error.msg toView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
