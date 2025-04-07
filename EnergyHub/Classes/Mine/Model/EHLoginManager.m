//
//  EHLoginManager.m
//  EnergyHub
//
//  Created by cpf on 2018/1/27.
//  Copyright © 2018年 EnergyHub. All rights reserved.
//

#import "EHLoginManager.h"
#import "EHTabbarController.h"
#import "EHNavigationViewController.h"
#import "EHLoginViewController.h"

@implementation EHLoginManager

+ (UIViewController *)currentController {
    EHTabbarController *tab = [[UIApplication sharedApplication] keyWindow].rootViewController;
    EHNavigationViewController *nav = tab.selectedViewController;
    return nav.visibleViewController;
}

+ (void)presentLoginController {
    UIViewController *vc = [self currentController];
    if (![vc isKindOfClass:[EHLoginViewController class]]) {
        EHLoginViewController *loginVC = [[EHLoginViewController alloc] init];
        [vc presentViewController:loginVC animated:YES completion:nil];
    }
}

@end
