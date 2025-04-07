//
//  EHTabbarController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/12.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHTabbarController.h"
#import "EHNavigationViewController.h"
#import "EHHomeViewController.h"
#import "EHOfflineViewController.h"
#import "EHBusinessViewController.h"
#import "EHMineViewController.h"
#import "EHLoginViewController.h"
#import "EHActivityListViewController.h"

@interface EHTabbarController ()

@property (nonatomic, strong) EHHomeViewController * homeVC;
@property (nonatomic, strong) EHOfflineViewController * offlineVC;
@property (nonatomic, strong) EHActivityListViewController * activityVC;
@property (nonatomic, strong) EHMineViewController * mineVC;

@end

@implementation EHTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBarColor];
    [self setupNotification];
    [self loadViewController];
}

- (void)setupTabBarColor {
    
    // 未选中状态的标题颜色
    /*
     [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:EHMainColor} forState:UIControlStateNormal];
     */
    // 选中状态的标题颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:EHMainColor} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [[UITabBar appearance] setTintColor:EHMainColor];
//    [[UITabBar appearance] setUnselectedItemTintColor:[UIColor lightTextColor]];
}

#pragma mark - DownloadCourseNotification

- (void)setupNotification {
   
    // 下载的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadCourse:)
                                                 name:DownloadCourseNotification
                                               object:nil];
    // 修改密码
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modifyPasswordSuccess)
                                                 name:ModifyPasswordSuccessNotification
                                               object:nil];
}

- (void)downloadCourse:(NSNotification *)notification {
    
    NSString *tid = notification.userInfo[@"tid"];
    self.selectedIndex = 1;
    [self.offlineVC downloadCourseWithId:tid];
}

- (void)modifyPasswordSuccess {
    if (self.selectedIndex != 3) {
        self.selectedIndex = 3;
    }
    UINavigationController *navi = self.selectedViewController;
    if ([navi isKindOfClass:[UINavigationController class]]) {
        EHLoginViewController *loginVC = [EHLoginViewController instance];
        [navi pushViewController:loginVC animated:YES];
    }
}

- (void)loadViewController
{
    EHNavigationViewController *nav1 = [[EHNavigationViewController alloc] initWithRootViewController:self.homeVC];
    EHNavigationViewController *nav2 = [[EHNavigationViewController alloc] initWithRootViewController:self.offlineVC];
    EHNavigationViewController *nav3 = [[EHNavigationViewController alloc] initWithRootViewController:self.activityVC];
    EHNavigationViewController *nav4 = [[EHNavigationViewController alloc] initWithRootViewController:self.mineVC];

    self.viewControllers = @[nav1, nav2, nav3, nav4];
}

#pragma mark - getter

- (EHHomeViewController *)homeVC {
    if (!_homeVC) {
        _homeVC = [[EHHomeViewController alloc] init];
        _homeVC.tabBarItem.title = @"首页";
        [_homeVC.tabBarItem setImage:[UIImage imageNamed:@"tab_home"]];
        [_homeVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_home_selected"]];
    }
    return _homeVC;
}


- (EHOfflineViewController *)offlineVC {
    if (!_offlineVC) {
        _offlineVC = [[EHOfflineViewController alloc] init];
        _offlineVC.tabBarItem.title = @"离线中心";
        [_offlineVC.tabBarItem setImage:[UIImage imageNamed:@"tab_offline"]];
        [_offlineVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_offline_selected"]];
    }
    return _offlineVC;
}

- (EHActivityListViewController *)activityVC {
    if (!_activityVC) {
        _activityVC = [[EHActivityListViewController alloc] init];
        _activityVC.tabBarItem.title = @"同城服务";
        [_activityVC.tabBarItem setImage:[UIImage imageNamed:@"tab_corp"]];
        [_activityVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_corp_selected"]];
    }
    return _activityVC;
}

- (EHMineViewController *)mineVC {
    if (!_mineVC) {
        _mineVC = [[EHMineViewController alloc] init];
        _mineVC.tabBarItem.title = @"我的";
        [_mineVC.tabBarItem setImage:[UIImage imageNamed:@"tab_mine"]];
        [_mineVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_mine_selected"]];
    }
    return _mineVC;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
