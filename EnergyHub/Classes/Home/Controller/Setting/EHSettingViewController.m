//
//  EHSettingViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/7.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHSettingViewController.h"
#import "EHShareManager.h"
#import <SDImageCache.h>
#import "EHHomeService.h"

#define kSettingItems @[@{@"title": @"会员信息修改", @"class": @"EHUserInfoModifyViewController"}, \
                        @{@"title": @"用户反馈", @"class": @"EHFeedbackViewController"}, \
                        @{@"title": @"关于", @"class": @"EHAboutViewController"}, \
                        @{@"title": @"帮助信息", @"class": @"EHHelpViewController"}, \
                        @{@"title": @"清除缓存", @"class": @"clear"}, \
                        @{@"title": @"分享我的学习", @"class": @"share"}, \
                        @{@"title": @"注销账号", @"class": @"delete"} \
                       ]

@interface EHSettingViewController ()

@property (nonatomic, strong) EHHomeService *homeService;

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
    self.tableView.backgroundColor = kBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    // 退出按钮
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    container.backgroundColor = EHSeparatorColor;
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.backgroundColor = kBackgroundColor;
    logoutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton setTitleColor:EHFontColor forState:UIControlStateNormal];
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
    cell.backgroundColor = kBackgroundColor;
    cell.textLabel.textColor = EHFontColor;
    selectedBackground.backgroundColor = EHMainColor;
    cell.selectedBackgroundView = selectedBackground;
    // data
    NSDictionary *dataSource = kSettingItems[indexPath.row];
    cell.textLabel.text = [dataSource objectForKey:@"title"];
    if ([dataSource[@"class"] isEqualToString:@"clear"]) {
        cell.detailTextLabel.text = @"0.0M";
        // 获取图片缓存
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CGFloat size = [SDImageCache sharedImageCache].getSize / 1024 / 1024.;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1lfM", size];
            });
        });
    }
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8.f)];
    header.backgroundColor = EHSeparatorColor;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *dataSource = kSettingItems[indexPath.row];
    NSString *className = [dataSource objectForKey:@"class"];
    if ([className isEqualToString:@"share"]) {
        // 分享
        [EHShareManager shareToView:self.view inviteCode:nil];
        return;
    }else if ([className isEqualToString:@"clear"]) {
        [[SDImageCache sharedImageCache] clearMemory];
        DefineWeakSelf
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [MBProgressHUD showError:@"清除成功" toView:weakSelf.view];
            [weakSelf.tableView reloadData];
        }];
        return;
    } else if ([className isEqualToString:@"delete"]) {
        [self showDeleteDialog];
        return;
    }
    // 根据类名创建VC
    Class clazz = NSClassFromString(className);
    UIViewController *toController = [clazz instance];
    
    if ([toController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:toController animated:YES];
    }
}

#pragma mark - 注销账号

- (void)showDeleteDialog {
    //初始化弹窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"账号注销不可恢复，确认要注销账号？" preferredStyle:UIAlertControllerStyleAlert];
    DefineWeakSelf
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteAccount];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    //弹出提示框
    [self presentViewController:alert animated:true completion:nil];
}

- (void)deleteAccount {
    DefineWeakSelf
    NSDictionary *params = @{@"customerId": [EHUserInfo sharedUserInfo].Id, @"token": [EHUserInfo sharedUserInfo].token};
    [self.homeService deleteAccountWithParam:params successBlock:^(NSDictionary *) {
        [MBProgressHUD showError:@"注销成功" toView:weakSelf.view];
        [weakSelf logoutAction];
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:@"注销失败" toView:weakSelf.view];
    }];
}

#pragma mark - Getters

- (EHHomeService *)homeService {
    if (!_homeService) {
        _homeService = [[EHHomeService alloc]init];
    }
    return _homeService;
}

#pragma mark - Memory Methods

- (void) dealloc {
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
