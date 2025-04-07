//
//  EHBaseService.h
//  EnergyHub
//
//  Created by gjy on 17/8/13.
//  Copyright © 2017年 www.siyu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRequest.h"
#import "EHHttpClient.h"
#import "EHBaseParam.h"
#import "EHHttpDriver.h"
#import "MJExtension.h"
#import "EHGlobal.h"

#define EHHttpURL(url) [EHBaseService apiURLWithURL:url]
#define EHHttpRestURL(url) [EHBaseService apiRestURLWithURL:url]
#define EHHttpsURL(url) [EHBaseService httpsApiURLWithURL:url]
#define EHChatHttpURL(_context) [EHBaseService chatApiUrlWithContext:(_context)]

@interface EHBaseService : NSObject

/**
 *  @brief http完整的URL地址.
 *
 *  @param api 传入url地址. 例如 zd/地址 或 传入 /zd/地址.
 *
 *  @return 完整的URL地址.
 */
+ (NSString *) apiURLWithURL:(NSString *) api ;

+ (NSString *) apiRestURLWithURL:(NSString *) api ;

/*
 * 聊天url，使用另外的端口
 */
+ (NSString *)chatApiUrlWithContext:(NSString *)context;

/**
 *  @brief https完整的URL地址.
 *
 *  @param httpsApi 传入url地址. 例如 zd/地址 或 传入 /zd/地址.
 *
 *  @return 完整的URL地址.
 */
+ (NSString *) httpsApiURLWithURL:(NSString *) httpsApi ;

#pragma mark - 实例方法, 创建service对象，发送请求.

/**
 *  发送Get请求.
 *
 *  @param url     get请求地址
 *  @param params  继承自NSObEHct的对象.
 *  @param success
 *  @param error
 *
 *  @return request对象
 */
- (EHRequest *) sendGetRequestWithURL:(NSString *) url
                               params:(id) params
                              success:(EHSuccessBlock) success
                                error:(EHErrorBlock) error ;

/**
 *  发送Get请求.
 *
 *  @param url     get请求地址
 *  @param params  继承自NSObEHct的对象.
 *  @param success
 *  @param error
 *
 *  @return request对象
 */
- (EHRequest *) sy_sendGetRequestWithURL:(NSString *) url
                                  params:(id) params
                                 success:(EHSuccessBlock) success
                                   error:(EHErrorBlock) error ;

/**
 *  发送Post请求.
 *
 *  @param url     post请求地址
 *  @param params  继承自NSObEHct的对象.
 *  @param  success
 *  @param  error
 *
 *  @return request对象
 */
- (EHRequest *) sendPostRequestWithURL:(NSString *) url
                                params:(id) params
                               success:(EHSuccessBlock) success
                                 error:(EHErrorBlock) error ;
/*
 json post
 */

- (EHRequest *) sendJSONPostRequestWithURL:(NSString *) url
                                params:(id) params
                               success:(EHSuccessBlock) success
                                 error:(EHErrorBlock) error ;

/**
 *  @brief 上传文件的post请求.
 *
 *  @param url              post的url地址.
 *  @param params           继承自NSObEHct的对象.
 *  @param formDataArray    上传文件的数据.数组对象为EHFormData对象
 *  @param success          请求成功的回调.
 *  @param error            请求失败的回调.
 *
 *  @return 请求对象.
 */
- (EHRequest *) postRequestWithURL:(NSString *) url
                            params:(id) params
                     formDataArray:(NSArray *) formDataArray
                           success:(EHSuccessBlock) success
                             error:(EHErrorBlock) error ;

/**
 *  @brief Delete请求.
 *
 *  @param url              post的url地址.
 *  @param params           继承自NSObEHct的对象.
 *  @param success          请求成功的回调.
 *  @param error            请求失败的回调.
 *
 *  @return 请求对象.
 */

- (EHRequest *) sendDeleteRequestWithURL:(NSString *) url
                                  params:(id) params
                                 success:(EHSuccessBlock) success
                                   error:(EHErrorBlock) error;

/**
 *  @brief put请求.
 *
 *  @param url              post的url地址.
 *  @param params           继承自NSObEHct的对象.
 *  @param success          请求成功的回调.
 *  @param error            请求失败的回调.
 *
 *  @return 请求对象.
 */

- (EHRequest *) sendPutRequestWithURL:(NSString *) url
                               params:(id) params
                              success:(EHSuccessBlock) success
                                error:(EHErrorBlock) error;

- (EHRequest *) sendJSONPutRequestWithURL:(NSString *) url
                                   params:(id) params
                                  success:(EHSuccessBlock) success
                                    error:(EHErrorBlock) error;

#pragma mark - 类方法

/**
 *  发送Get请求.
 *
 *  @param url     get请求地址
 *  @param params  继承自NSObEHct的对象.
 *  @param success
 *  @param error
 *
 *  @return request对象
 */
+ (EHRequest *) sendGetRequestWithURL:(NSString *) url
                               params:(id) params
                              success:(EHSuccessBlock) success
                                error:(EHErrorBlock) error ;

/**
 *  发送Post请求.
 *
 *  @param url     post请求地址
 *  @param params  继承自NSObEHct的对象.
 *  @param success @see EHSuccessBlock
 *  @param error   @see EHErrorBlock
 *
 *  @return request对象
 */
+ (EHRequest *) sendPostRequestWithURL:(NSString *) url
                                params:(id) params
                               success:(EHSuccessBlock) success
                                 error:(EHErrorBlock) error ;

+ (EHRequest *) sendJSONPostRequestWithURL:(NSString *) url
                                    params:(id) params
                                   success:(EHSuccessBlock) success
                                     error:(EHErrorBlock) error ;



/**
 *  @brief 上传文件的post请求.
 *
 *  @param url              post的url地址.
 *  @param params           继承自NSObEHct的对象.
 *  @param formDataArray    上传文件的数据.数组对象为EHFormData对象
 *  @param success          请求成功的回调.
 *  @param error            请求失败的回调.
 *
 *  @return 请求对象.
 */
+ (EHRequest *) postRequestWithURL:(NSString *) url
                            params:(id) params
                     formDataArray:(NSArray *) formDataArray
                           success:(EHSuccessBlock) success
                             error:(EHErrorBlock) error ;

@end
