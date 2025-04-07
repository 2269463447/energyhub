//
//  UIImageView+LoadImage.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LoadImage)

- (void) loadImageWithURL:(NSString *)urlString;
// URL 需要拼接服务器地址
- (void) loadImageWithRelativeURL:(NSString *)urlString;

- (void) loadAvatarImageWithURL:(NSString *)urlString ;

@end
