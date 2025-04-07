//
//  EHShareManager.h
//  EnergyHub
//
//  Created by sky on 07/15/19.
//  Copyright © 2019 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "WXApi.h"
//#import "WeiboSDK.h"

typedef enum : NSUInteger {
    JEWXScenceTypeSession,         // 好友
    JEWXScenceTypeTimeline         // 朋友圈
} JEWXScenceType;

typedef void (^JEWeixinShareCompletionBlock) (BOOL success, NSString *errorMessage);

@interface EHShareManager : NSObject

+ (EHShareManager *)instance;

+ (void)configPlatforms;
+ (BOOL)handleOpenURL:(NSURL *)url;
/**
 分享能量库app
 
 @param view 分享指定页面
 @param inviteCode 邀请码 可以为空
 */
+ (void)shareToView:(UIView *)view inviteCode:(NSString *)inviteCode;

+ (void)shareInfo:(NSDictionary *)info inView:(UIView *)view; // 分享课程链接

@end
