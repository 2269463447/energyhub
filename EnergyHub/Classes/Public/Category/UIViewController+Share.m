//
//  UIViewController+Share.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/5.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "UIViewController+Share.h"
#import "EHShareManager.h"
#import "EHLoginViewController.h"

@implementation UIViewController (Share)

- (void)facilitateShare {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"share"] selecteImage:nil frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(shareApp)];

}

- (void)facilitateShareAndSetting {
    
    UIBarButtonItem *shareItem = [UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"share"] selecteImage:nil frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(shareApp)];
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"setting"] selecteImage:nil frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(gotoSetting)];
    self.navigationItem.rightBarButtonItems = @[settingItem, shareItem];
}

- (void)gotoSetting {
    
    if(![EHUserInfo sharedUserInfo].isLogin) {
//        [MBProgressHUD showError:@"请先登录" toView:self.view];
        EHLoginViewController *login = [EHLoginViewController instance];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    UIViewController *setting = [NSClassFromString(@"EHSettingViewController") instance];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)shareApp {
    [EHShareManager shareToView:self.view inviteCode:nil];
}

@end
