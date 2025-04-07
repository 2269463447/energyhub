//
//  EHSettingViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/7.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHSettingViewController.h"
#import "EHShare.h"


#define kSettingItems @[@{@"title": @"会员信息修改", @"class": @"EHUserInfoModifyViewController"}, \
                        @{@"title": @"用户反馈", @"class": @"EHFeedbackViewController"}, \
                        @{@"title": @"关于", @"class": @"EHAboutViewController"}, \
                        @{@"title": @"帮助信息", @"class": @"EHHelpViewController"}, \
                        @{@"title": @"分享我的学习", @"class": @"share"} \
                       ]

@interface EHSettingViewController ()

@end

@implementation EHSettingViewController

#pragma mark - Life Cycle Methods

- (void) viewDidLoad {
    [super viewDidLoad] ;
    // 加载UI
    [self setupUI] ;
}

#pragma mark - Private Methods

- (void) setupUI {
    self.title = @"设置";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    // 退出按钮
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    container.backgroundColor = kBackgroundColor;
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.backgroundColor = [UIColor whiteColor];
    logoutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton setTitleColor:EHTextBlackColor forState:UIControlStateNormal];
    logoutButton.frame = CGRectMake(0, 15, kScreenWidth, 50);
    [logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:logoutButton];
    self.tableView.tableFooterView = container;
}

#pragma mark - logout

- (void)logoutAction {
    
    [[EHUserInfo sharedUserInfo] logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return kSettingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UIView *selectedBackground = [UIView new];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = EHTextBlackColor;
    selectedBackground.backgroundColor = EHMainColor;
    cell.selectedBackgroundView = selectedBackground;
    // data
    NSDictionary *dataSource = kSettingItems[indexPath.row];
    cell.textLabel.text = [dataSource objectForKey:@"title"];
    //cell.imageView.image = [dataSource objectForKey:@"image"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 调整文字与图标的距离
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 8.f ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *dataSource = kSettingItems[indexPath.row];
    NSString *className = [dataSource objectForKey:@"class"];
    if ([className isEqualToString:@"share"]) {
        // 分享
        [EHShare shareToView:self.view inviteCode:nil];
        return;
    }
    // 根据类名创建VC
    Class clazz = NSClassFromString(className);
    UIViewController *toController = [clazz instance];
    
    if ([toController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:toController animated:YES];
    }
}

#pragma mark - Memory Methods

- (void) dealloc {
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
