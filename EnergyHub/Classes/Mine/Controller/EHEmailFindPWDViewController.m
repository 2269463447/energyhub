//
//  EHEmailFindPWDViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/9/16.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHEmailFindPWDViewController.h"
#import "EHMineService.h"
#import <ReactiveObjC.h>
#import "UIImage+Color.h"

@interface EHEmailFindPWDViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;
@property (strong, nonatomic) EHMineService *service;

@end

@implementation EHEmailFindPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self buttonIsCanClick];
}

- (void)buttonIsCanClick {
    
    [self.enterBtn setBackgroundImage:[UIImage createImageWithColor:EHMainColor] forState:UIControlStateNormal];
    [self.enterBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#999999"]] forState:UIControlStateDisabled];

    
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.accountTF.rac_textSignal, self.emailTF.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        return @([value[0] length] > 0 && [Utils validateEmail:value[1]]);
    }];
    
    self.enterBtn.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
    
}

- (EHMineService *)service {
    if (!_service) {
        _service = [[EHMineService alloc] init];
    }
    return _service;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterBtnAction:(id)sender {
    
    
    if (self.accountTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入账号" toView:self.view];
        return;
    }
    
    if (self.emailTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入邮箱" toView:self.view];
        return;
    }
    
    if (![Utils validateEmail:self.emailTF.text]) {
        [MBProgressHUD showError:@"请输入正确邮箱" toView:self.view];
        return;
    }

    DefineWeakSelf
    [self.service emailFindPWdParam:@{@"userName": self.accountTF.text,
                                      @"email":self.emailTF.text}
                       successBlock:^(NSDictionary *dic) {
                                          
                           NSString *code = [dic objectForKey:@"code"];
                           if ([code isEqualToString:EHSuccessCode]) {
                               [MBProgressHUD showSuccess:@"密码已发送至邮箱" toView:weakSelf.view];
                           }else{
                               NSString *errorMsg = dic[@"errorMsg"];
                               [MBProgressHUD showError:errorMsg toView:weakSelf.view];
                           }
        
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
