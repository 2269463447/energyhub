//
//  UIViewController+Share.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/5.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseViewController.h"
#import "UIBarButtonItem+Extension.h"

@interface UIViewController (Share)

// 只有分享
- (void)facilitateShare;
// 分享和设置
- (void)facilitateShareAndSetting;

@end
