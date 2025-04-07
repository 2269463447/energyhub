//
//  EHMineService.h
//  EnergyHub
//
//  Created by cpf on 2017/8/22.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHBaseService.h"
#import "EHReleasedCourseData.h"

@interface EHMineService : EHBaseService

/**
 登录
 */
- (void)loginDataWithParam:(NSDictionary *)param
              successBlock:(void (^)(EHUserInfo *userInfo))successBlock
                errorBlock:(EHErrorBlock)errorBlock;

/**
 注册
 */
- (void)registerDataWithParam:(NSDictionary *)param
                 successBlock:(void (^)(id obj))successBlock
                   errorBlock:(EHErrorBlock)errorBlock;

/** 上传图片 */
- (void)updateAvatarImageWithParam:(NSDictionary *)param
                             image:(UIImage *)image
                         imageData:(NSData *)imageData
                          filename:(NSString *)filename
                      successBlock:(void (^)(NSString *))successBlock
                        errorBlock:(EHErrorBlock)errorBlock;

/** 已发布的课程[教师权限] */
- (void)releasedCourseWithParam:(NSDictionary *)param
                      successBlock:(void (^)(NSArray *courseList))successBlock
                        errorBlock:(EHErrorBlock)errorBlock;

/** App二维码 */
- (void)appQRCodeWithParam:(NSDictionary *)param
                   successBlock:(void (^)(NSDictionary *qrcode))successBlock
                     errorBlock:(EHErrorBlock)errorBlock;

/**
 申请成为老师
 */
- (void)applyTeacherDataWithParam:(NSDictionary *)param
                     successBlock:(void (^)(id obj))successBlock
                       errorBlock:(EHErrorBlock)errorBlock;

/**
 申请发布课程
 */
- (void)releaseClassDataWithParam:(NSDictionary *)param
                     successBlock:(void (^)(id obj))successBlock
                       errorBlock:(EHErrorBlock)errorBlock;

/**
 消费记录
 */
- (void)recordsConsumptionDataWithParam:(NSDictionary *)param
                           successBlock:(void (^)(id obj))successBlock
                             errorBlock:(EHErrorBlock)errorBlock;

/**
 收入明细
 */
- (void)costListDataWithParam:(NSDictionary *)param
                 successBlock:(void (^)(id obj))successBlock
                   errorBlock:(EHErrorBlock)errorBlock;

/**
 提现记录
 */
- (void)cashWithdrawalListDataWithParam:(NSDictionary *)param
                           successBlock:(void (^)(id obj))successBlock
                             errorBlock:(EHErrorBlock)errorBlock;

/**
 提现申请
 */
- (void)applyForCashWithdrawalsDataWithParam:(NSDictionary *)param
                                successBlock:(void (^)(id obj))successBlock
                                  errorBlock:(EHErrorBlock)errorBlock;

/**
 获取验证码
 */
- (void)verificationCodeDataWithParam:(NSDictionary *)param
                         successBlock:(void (^)(id obj))successBlock
                           errorBlock:(EHErrorBlock)errorBlock;

/**
 快速注册,手机注册
 */
- (void)fastRegisterDataWithParam:(NSDictionary *)param
                     successBlock:(void (^)(id obj))successBlock
                       errorBlock:(EHErrorBlock)errorBlock;

/**
 邮箱找回密码
 */
- (void)emailFindPWdParam:(NSDictionary *)param
             successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock;

/**
 手机号找回密码
 */
- (void)phoneFindPWdParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock;

/**
 申请老师状态
 */
- (void)teacherStatusWithParam:(NSDictionary *)param
             successBlock:(void (^)(NSDictionary *))successBlock
               errorBlock:(EHErrorBlock)errorBlock;

/**
 充值记录
 */
- (void)rechargeRecordParam:(NSDictionary *)param
                  successBlock:(void (^)(NSDictionary *))successBlock
                    errorBlock:(EHErrorBlock)errorBlock;
/**
 验证苹果充值结果
 */
- (void)verifyAppstoreReceiptWithParam:(NSDictionary *)param
                          successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock;
/**
 游客登录
 */

- (void)tmpUserLoginSuccessBlock:(void (^)(NSDictionary *))successBlock
                      errorBlock:(EHErrorBlock)errorBlock;


/*
 团队详情
 */
- (void)teamDetailWithParam:(NSDictionary *)param
               successBlock:(void (^)(NSDictionary *))successBlock
                 errorBlock:(EHErrorBlock)errorBlock;

/*
 获取可提现金额
 */
- (void)withdrawDetailWithParam:(NSDictionary *)param
               successBlock:(void (^)(NSDictionary *))successBlock
                 errorBlock:(EHErrorBlock)errorBlock;

/*
 提现
 */
- (void)withdrawWithParam:(NSDictionary *)param
               successBlock:(void (^)(NSDictionary *))successBlock
                 errorBlock:(EHErrorBlock)errorBlock;

@end
