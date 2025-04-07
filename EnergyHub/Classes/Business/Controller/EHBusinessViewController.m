//
//  EHBusinessViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/12.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHBusinessViewController.h"
#import "EHBusinessCell.h"
#import "EHFriendlyLinkViewController.h"
#import "EHBeShareholderViewController.h"
#import "EHAdvertisementViewController.h"
#import "EHCooperateViewController.h"
#import "EHStatementViewController.h"
#import "EHBeATeacherViewController.h"
#import "EHEliteJoinViewController.h"
//#import "EHShareManager.h"
#import "UIBarButtonItem+Extension.h"
#import "EHSettingViewController.h"
#import "UIViewController+Share.h"
#import "EHLoginViewController.h"

static NSString * cellIdentifier = @"EHBusinessCell";

@interface EHBusinessViewController ()<UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * dataSource;

@end

@implementation EHBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = kBackgroundColor;
    self.tableView.rowHeight = 50;
    self.tableView.estimatedSectionHeaderHeight = 8;
    [self.tableView registerNib:[UINib nibWithNibName:@"EHBusinessCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self facilitateShareAndSetting];
}

#pragma mark -- getter

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"关于本站互换友情链接的说明",
                        @"关于个人怎么申请成为本站老师，并发布课程",
                        @"关于单位机构如何在本站进行商务合作",
                        @"关于能量库教育网声明",
                        @"关于单位机构如何与本站进行广告合作",
                        @"关于精英人才如何加盟能量库教育网团队",
                        @"关于如何投资本站，加入我们的大家庭，成为股东"];
    }
    return _dataSource;
}

#pragma mark -- UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHBusinessCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.title = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushViewControllerByIndex:indexPath.row];
}

- (void)pushViewControllerByIndex:(NSInteger)index {
    NSString * title = self.dataSource[index];
    
    if ([title containsString:@"链接"]) {
        
        EHFriendlyLinkViewController * friendVC = [[EHFriendlyLinkViewController alloc] init];
        friendVC.title = @"友情链接";
        friendVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendVC animated:YES];
        
    }else if ([title containsString:@"老师"]) {
        if (![EHUserInfo sharedUserInfo].isLogin) {
//            [MBProgressHUD showError:@"请先登录" toView:self.view];
            EHLoginViewController *login = [EHLoginViewController instance];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        
        EHBeATeacherViewController * helpVC = [[EHBeATeacherViewController alloc] init];
        helpVC.title = @"如何成为老师";
        helpVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:helpVC animated:YES];

        
    }else if ([title containsString:@"商务合作"]) {
        
        EHCooperateViewController * cooperateVC = [[EHCooperateViewController alloc] init];
        cooperateVC.title = @"合作";
        cooperateVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cooperateVC animated:YES];

    }else if ([title containsString:@"声明"]) {
        
        EHStatementViewController * statementVC = [[EHStatementViewController alloc] init];
        statementVC.title = @"能量库教育网声明";
        statementVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:statementVC animated:YES];

    }else if ([title containsString:@"广告"]) {
        
        EHAdvertisementViewController * advertisementVC = [[EHAdvertisementViewController alloc] initWithStyle:UITableViewStyleGrouped];
        advertisementVC.title = @"如何与本站进行广告合作";
        advertisementVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:advertisementVC animated:YES];

    }else if ([title containsString:@"加盟"]) {
        
        EHEliteJoinViewController * joinVC = [[EHEliteJoinViewController alloc] init];
        joinVC.title = @"精英加盟";
        joinVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:joinVC animated:YES];
        
    }else if ([title containsString:@"股东"]) {
        EHBeShareholderViewController * shareholderVC = [[EHBeShareholderViewController alloc] init];
        shareholderVC.title = @"如何成为股东";
        shareholderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shareholderVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
