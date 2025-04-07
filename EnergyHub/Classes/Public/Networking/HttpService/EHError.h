//
//  JEError.h
//  JiaeD2C
//
//  Created by Caiyanzhi on 15/8/22.
//  Copyright (c) 2015年 www.jiae.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNetworkError @"网络异常"
#define kOtherError   @"其他错误"

#define kOtherErrorCode -100
// token失效
#define kTokenInvalidCode @"666666"
// 服务器内部错误
#define kServerErrorCode  500


typedef NS_ENUM(NSUInteger, EHErrorType) {
    EHNetWorkError = 1,        // 网络错误
    EHAPIError,                // API返回错误
    EHAliPayError,             // AliPay支付错误
    EHOtherError               // 其他错误
};

/**
 *  @brief 网络请求错误处理类(和具体业务相关).
 */
@interface EHError : NSObject

@property (nonatomic, assign) EHErrorType errorType ;
@property (nonatomic, assign) NSInteger code ;
@property (nonatomic, copy) NSString *msg ;

/**
 *  @brief 初始化方法.
 *
 *  @param errorType 响应错误类型.
 *  @param code      响应错误code.
 *  @param msg       响应错误信息.
 *
 *  @return 当前Error对象.
 */
+ (instancetype) errorWithType:(EHErrorType) errorType
                          code:(NSInteger) code
                       message:(NSString *) msg ;

@end
