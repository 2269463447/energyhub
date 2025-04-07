//
//  EHUserInfo.m
//  EnergyHub
//
//  Created by cpf on 2017/8/22.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHUserInfo.h"
#import <MJExtension.h>

// 用户登录之后缓存的路径
#define UserDataPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.data"]

static EHUserInfo *staticUserinfo = nil;

@implementation EHUserInfo

// 实现coding
MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"Id": @"id"};
}

#pragma mark - Public Methods

+ (EHUserInfo *)sharedUserInfo {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!staticUserinfo) {
            staticUserinfo = [NSKeyedUnarchiver unarchiveObjectWithFile:UserDataPath];
        }else {
            staticUserinfo = [[EHUserInfo alloc] init];
        }
    });
    return staticUserinfo;
}

+ (void)loginWithData:(EHUserInfo *)data {
    
    staticUserinfo = data;
    staticUserinfo.isLogin = YES;
    [self saveUserData:data];
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification
                                                        object:nil];
}

+ (void)updateUserData {
    // 更新数据
    [self saveUserData:staticUserinfo];
}

- (void)logOut {
    // 退出时清除缓存数据
    [self clearUserData];
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotification object:nil];
}

+ (void)saveUserData:(EHUserInfo *)data {
    // 归档数据
    [NSKeyedArchiver archiveRootObject:data toFile:UserDataPath];
}

- (void)clearUserData {
    staticUserinfo = nil;
    // 删除缓存数据
    [[NSFileManager defaultManager] removeItemAtPath:UserDataPath error:nil];
}

- (BOOL)isTeacher {
    
    return [_roleid integerValue] == 1;
}

- (BOOL)isAffordable:(CGFloat)price {
    
//    if ([_account_apple floatValue] >= price) {
//        return YES;
//    }
//    后台判断
    return YES;
}

@end
