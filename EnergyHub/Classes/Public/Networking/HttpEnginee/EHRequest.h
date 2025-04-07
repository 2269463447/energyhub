//
//  JERequest.h
//  JiaeD2C
//
//  Created by Caiyanzhi on 15/8/22.
//  Copyright (c) 2015年 www.jiae.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  HttpDriver返回的网络请求对象.
 */
@interface EHRequest : NSObject

@property (nonatomic, strong) NSOperation *operation ;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask ;

+ (instancetype) requestWithOperation:(NSOperation *) operation ;
+ (instancetype) requestWithDataTask:(NSURLSessionDataTask *) dataTask ;

/**
 *  取消网络请求的方法.
 */
- (void) cancelRequest ;

@end
