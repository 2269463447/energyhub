//
//  EHError.m
//  JiaeD2C
//
//  Created by Caiyanzhi on 15/8/22.
//  Copyright (c) 2015年 www.jiae.com. All rights reserved.
//

#import "EHError.h"

@implementation EHError

+ (instancetype) errorWithType:(EHErrorType) errorType
                          code:(NSInteger) code
                       message:(NSString *) msg {
    EHError *error = [[EHError alloc] init] ;
    error.errorType = errorType ;
    error.code = code ;
    error.msg = msg ;
    if (errorType == EHOtherError && error.msg.length <= 0) {
        error.msg = kOtherError ;
    }
    
    if (errorType == EHNetWorkError && error.msg.length <= 0) {
        error.msg = kNetworkError ;
    }
    
    if (error.code == kServerErrorCode) {
        error.msg = @"服务器发生错误";
    }
    
    if ([error.msg isKindOfClass:[NSNull class]]) {
        error.msg = @"未知错误";
    }
    
    return error ;
}

@end
