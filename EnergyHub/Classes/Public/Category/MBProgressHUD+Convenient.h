//
//  MBProgressHUD+Convenient.h
//  EnergyHub
//
//  Created by cpf on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Convenient)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error toView:(UIView *)view;
#pragma mark 显示UIActivityIndicatorView和一些信息
+ (void)showLoading:(NSString *)message toView:(UIView *)view;

@end
