//
//  EHHomeService.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/14.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHBaseService.h"
#import "EHHomeBannerData.h"
#import "EHHomeCourseData.h"
#import "EHCourseListData.h"
#import "EHCourseDetail.h"

@interface EHHomeService : EHBaseService


/*
 * 消息状态：首页左上角小红点
 */

- (void)messageStatusWithParam:(NSDictionary *)param
                  successBlock:(void (^)(NSInteger))successBlock
                    errorBlock:(EHErrorBlock)errorBlock;

/*
 * 首页banner和推荐
 */
- (void)homeBannerDataWithParam:(NSDictionary *)param
                   successBlock:(void (^)(EHHomeBannerData *))successBlock
                     errorBlock:(EHErrorBlock)errorBlock;

/*
 * 首页一级课程列表
 */
- (void)homeCourseListWithParam:(NSDictionary *)param
                   successBlock:(void (^)(NSArray *))successBlock
                     errorBlock:(EHErrorBlock)errorBlock;

/*
 * 二级课程列表
 */
- (void)courseListWithParam:(NSDictionary *)param
               successBlock:(void (^)(NSArray *))successBlock
                 errorBlock:(EHErrorBlock)errorBlock;


/**
 三级课程列表
 */
- (void)menuListWithParam:(NSDictionary *)param successBlock:(void (^)(NSArray *))successBlock errorBlock:(EHErrorBlock)errorBlock;

/**
 视频播放
 */
- (void)videoDetailWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock;

/*
 *课程详情
 */
- (void)courseDetailWithParam:(NSDictionary *)param
             successBlock:(void (^)(EHCourseDetail *))successBlock
               errorBlock:(EHErrorBlock)errorBlock;

/*
 * 缓存课程的价格
 */
- (void)courseCostWithParam:(NSDictionary *)param
               successBlock:(void (^)(NSString *))successBlock
                 errorBlock:(EHErrorBlock)errorBlock;

/*
 * 支付宝
 */
- (void)alipayOrderWithParam:(NSDictionary *)param
                   successBlock:(void (^)(NSString *orderInfo))successBlock
                     errorBlock:(EHErrorBlock)errorBlock;

/*
 * 微信支付
 */
- (void)wxpayOrderWithParam:(NSDictionary *)param
                   successBlock:(void (^)(NSDictionary *orderInfo))successBlock
                     errorBlock:(EHErrorBlock)errorBlock;

/*
 * 用户反馈
 */
- (void)feedbackWithComment:(NSString *)comment
                imageInfo:(NSDictionary *)imageInfo
             successBlock:(void (^)(NSString *))successBlock
               errorBlock:(EHErrorBlock)errorBlock;

/*
 * 修改密码
 */
- (void)modifyPwdWithParam:(NSDictionary *)param
              successBlock:(void (^)(NSString *))successBlock
                errorBlock:(EHErrorBlock)errorBlock;

/*
 * 修改昵称
 */
- (void)modifyNicknameWithParam:(NSDictionary *)param
                   successBlock:(void (^)(NSString *))successBlock
                     errorBlock:(EHErrorBlock)errorBlock;

/*
 * 修改邮箱
 */
- (void)modifyEmailWithParam:(NSDictionary *)param
                successBlock:(void (^)(NSString *))successBlock
                  errorBlock:(EHErrorBlock)errorBlock;

/*
 * 修改性别
 */
- (void)modifySexWithParam:(NSDictionary *)param
              successBlock:(void (^)(NSString *))successBlock
                errorBlock:(EHErrorBlock)errorBlock;

/*
 * 修改个性签名
 */
- (void)modifySignatureWithParam:(NSDictionary *)param
              successBlock:(void (^)(NSString *))successBlock
                errorBlock:(EHErrorBlock)errorBlock;

/**
 单节课购买 alipay
 */
- (void)alipaySingalClassWithParam:(NSDictionary *)param successBlock:(void (^)(NSString *))successBlock errorBlock:(EHErrorBlock)errorBlock ;
/**
 单节课购买 weixin
 */

- (void)weixinPaySingalClassWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock ;

/**
 使用U币购买离线课程
 */
- (void)payForCourseWithParam:(NSDictionary *)param
                 successBlock:(void (^)(NSDictionary *))successBlock
                   errorBlock:(EHErrorBlock)errorBlock ;
/**
 使用U币购买单节课程
 */
- (void)payForOneWithParam:(NSDictionary *)param
                 successBlock:(void (^)(NSDictionary *))successBlock
                   errorBlock:(EHErrorBlock)errorBlock ;
/**
 使用U币打赏
 */
- (void)payForGiftWithParam:(NSDictionary *)param
              successBlock:(void (^)(NSDictionary *))successBlock
                errorBlock:(EHErrorBlock)errorBlock ;

/**
 账号注销
 */
- (void)deleteAccountWithParam:(NSDictionary *)param
                  successBlock:(void (^)(NSDictionary *))successBlock
                    errorBlock:(EHErrorBlock)errorBlock;

@end
