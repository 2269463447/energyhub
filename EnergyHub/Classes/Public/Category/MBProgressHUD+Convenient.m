//
//  MBProgressHUD+Convenient.m
//  EnergyHub
//
//  Created by cpf on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "MBProgressHUD+Convenient.h"

@implementation MBProgressHUD (Convenient)

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 7;
    hud.square = YES;
    hud.minSize = CGSizeMake(100, 100);
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    hud.label.font = [UIFont systemFontOfSize:14];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 2秒之后再消失
    [hud hideAnimated:YES afterDelay:1];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self show:success icon:@"success.png" view:view];
}

+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

#pragma mark 显示UIActivityIndicatorView和一些信息
+ (void)showLoading:(NSString *)message toView:(UIView *)view {
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [[self alloc] initWithView:view];
    [view addSubview:hud];
    hud.contentColor = [UIColor whiteColor];
    NSString *text = nil;
    NSString *detailText = nil;
    
    if (message.length > 10) {
        text = [message substringToIndex:10];
        detailText = [message substringFromIndex:10];
    } else {
        text = message;
        detailText = nil;
    }
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.label.text =  text;
    hud.margin = 7;
    hud.square = YES;
    hud.minSize = CGSizeMake(100, 100);
    hud.detailsLabel.text = detailText;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
}

@end
