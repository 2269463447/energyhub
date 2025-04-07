//
//  EHUserInfo.h
//  EnergyHub
//
//  Created by cpf on 2017/8/22.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//


#import <Foundation/Foundation.h>

#define IsLogin [EHUserInfo sharedUserInfo].isLogin

@interface EHUserInfo : NSObject<NSCoding>

@property (nonatomic, copy) NSString *account; // Android
@property (nonatomic, copy) NSString *account_apple;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *Id; // 用户id
@property (nonatomic, copy) NSString *invitecode;
@property (nonatomic, copy) NSString *machineCode;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *personSign;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *pwd;
/**是否是老师*/
@property (nonatomic, copy) NSString *roleid;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userrose;
@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, assign) BOOL isLogin;

+ (EHUserInfo *)sharedUserInfo;

+ (void)loginWithData:(EHUserInfo *)data;
+ (void)updateUserData;

- (void)logOut;
- (BOOL)isTeacher;
- (BOOL)isAffordable:(CGFloat)price;

@end
