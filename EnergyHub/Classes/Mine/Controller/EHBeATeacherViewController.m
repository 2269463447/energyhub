//
//  EHBeATeacherViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/31.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBeATeacherViewController.h"
#import "EHBeATeacherToolsView.h"
#import "EHApplyTeacherViewController.h"
#import "UIViewController+Share.h"
#import "EHMineService.h"

@interface EHBeATeacherViewController ()<EHBeATeacherToolsViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *teacherBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *classBackgroundView;

@property (nonatomic, strong) EHBeATeacherToolsView *teacherView;
@property (nonatomic, strong) EHBeATeacherToolsView *classView;
@property (nonatomic, strong) EHMineService *service;

@end

@implementation EHBeATeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startLoadData];
}

- (void)setupUI {
    self.view.backgroundColor = kBackgroundColor;
    [self.teacherBackgroundView addSubview:self.teacherView];
    [self.classBackgroundView addSubview:self.classView];
    [self facilitateShare];
}

- (void)startLoadData {
    
    DefineWeakSelf
    [self.service teacherStatusWithParam:@{} successBlock:^(NSDictionary *info) {
        [weakSelf updateStatusWithInfo:info];
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

- (void)updateStatusWithInfo:(NSDictionary *)info {
    
    // courseStatus = "";teacherStatus = 5;
    // 4 审核中 5 通过 6 未通过
    NSString *teacherText = [NSString stringWithFormat:@"%@", info[@"teacherStatus"]];
    if ([teacherText isKindOfClass:[NSString class]] && teacherText.length > 0) {
        NSInteger teacherStatus = [teacherText integerValue];
        if (teacherStatus == 5) {
            [self.teacherView updateStatusAtIndex:1];
        }else if (teacherStatus == 4) {
            [self.teacherView updateStatusAtIndex:2];
        }else {
            [self.teacherView updateStatusAtIndex:3];
        }
    }
    // 0 审核中 1 通过
    NSString *statusText = [NSString stringWithFormat:@"%@", info[@"courseStatus"]];
    if ([statusText isKindOfClass:[NSString class]] && statusText.length > 0) {
        NSInteger classStatus = [statusText integerValue];
        if (classStatus == 1) {
            [self.classView updateStatusAtIndex:1];
        }else if (classStatus == 0) {
            [self.classView updateStatusAtIndex:2];
        }else {
            [self.classView updateStatusAtIndex:3];
        }
    }
}

#pragma mark -- EHBeATeacherToolsViewDelegate

- (void)didSelectView:(EHBeATeacherToolsView *)toolsView index:(NSInteger)index {
    
    if (toolsView == self.teacherView) {
        
        switch (index) {
            case 0:
            {
                if ([[EHUserInfo sharedUserInfo].roleid isEqualToString:@"1"]) {
                    [MBProgressHUD showError:@"亲，你已经是老师了" toView:self.view];
                    return;
                }
                EHApplyTeacherViewController * applyVC = [[EHApplyTeacherViewController alloc] initWithStyle:EHBeTeacherStyle];
                applyVC.title = @"申请成为网站课程老师";
                [self.navigationController pushViewController:applyVC animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }else {
        
        switch (index) {
            case 0:
            {
                
//                if ([[EHUserInfo sharedUserInfo].roleid isEqualToString:@"0"]) {
//                    [MBProgressHUD showError:@"申请成为老师才能发布课程" toView:self.view];
//                    return;
//                }
                EHApplyTeacherViewController * applyVC = [[EHApplyTeacherViewController alloc] initWithStyle:EHShowClassStyle];
                applyVC.title = @"申请发布课程";
                [self.navigationController pushViewController:applyVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -- Getter

- (EHBeATeacherToolsView *)teacherView {
    if (!_teacherView) {
        _teacherView = [[EHBeATeacherToolsView alloc] initWithFrame:CGRectMake(0, 0, self.teacherBackgroundView.width, self.teacherBackgroundView.height) withTitleArray:@[@"申请成为老师", @"通过", @"审核中", @"未通过"]];
        _teacherView.delegate = self;
    }
    return _teacherView;
}

- (EHBeATeacherToolsView *)classView {
    if (!_classView) {
        _classView = [[EHBeATeacherToolsView alloc] initWithFrame:CGRectMake(0, 0, self.classBackgroundView.width, self.classBackgroundView.height) withTitleArray:@[@"申请发布课程", @"通过", @"审核中", @"未通过"]];
        _classView.delegate = self;
    }
    return _classView;
}

- (EHMineService *)service {
    if (!_service) {
        _service = [[EHMineService alloc]init];
    }
    return _service;
}

@end
