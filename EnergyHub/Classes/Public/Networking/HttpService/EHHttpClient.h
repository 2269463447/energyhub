//
//  EHHttpClient.h
//  JiaeD2C
//
//  Created by Caiyanzhi on 15/8/22.
//  Copyright (c) 2015年 www.jiae.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRequest.h"
#import "EHError.h"

typedef void (^EHSuccessBlock) (NSDictionary *responseDictinary) ;
typedef void (^EHErrorBlock) (EHError *error);

@interface EHHttpClient : NSObject

/**
 *  @brief 单例方法，使用当前类请用此方法创建.
 *
 *  @return 当前对象的实例.
 */
+ (instancetype) sharedInstance ;


/**
 *  @brief 发送一个get请求.
 *
 *  @param url      get请求的url地址.
 *  @param params   请求的参数，封装成NSDictionary对象.
 *  @param successBlock  请求成功的回调.
 *  @param errorBlock    请求失败的回调.
 *
 *  @return 请求对象.
 */
- (EHRequest *) sendGetRequestWithURL:(NSString *) url
                               params:(NSDictionary *) params
                              success:(EHSuccessBlock) successBlock
                                error:(EHErrorBlock) errorBlock ;

/**
 *  @brief 发送一个get请求.
 *
 *  @param url      get请求的url地址.
 *  @param params   请求的参数，封装成NSDictionary对象.
 *  @param successBlock  请求成功的回调.
 *  @param errorBlock    请求失败的回调.
 *
 *  @return 请求对象.
 */
- (EHRequest *) sy_sendGetRequestWithURL:(NSString *) url
                                  params:(NSDictionary *) params
                                 success:(EHSuccessBlock) successBlock
                                   error:(EHErrorBlock) errorBlock;


/**
 *  @brief 发送一个Post请求.
 *
 *  @param url      post请求的url地址.
 *  @param params   请求的参数，封装成NSDictionary对象.
 *  @param successBlock  请求成功的回调.
 *  @param errorBlock    请求失败的回调.
 *
 *  @return 请求对象.
 */
- (EHRequest *) sendPostRequestWithURL:(NSString *) url
                                params:(NSDictionary *) params
                               success:(EHSuccessBlock) successBlock
                                 error:(EHErrorBlock) errorBlock ;


/**
 *  @brief 上传文件的post请求.
 *
 *  @param url              请求的url地址.
 *  @param params           请求的参数.
 *  @param formDataArray    上传文件的数据.数组对象为EHFormData对象
 *  @param successBlock          请求成功的回调.
 *  @param errorBlock            请求失败的回调.
 *
 *  @return 请求对象.
 */
- (EHRequest *) postRequestWithURL:(NSString *) url
                            params:(NSDictionary *) params
                     formDataArray:(NSArray *) formDataArray
                           success:(EHSuccessBlock) successBlock
                             error:(EHErrorBlock) errorBlock ;

/**
 *  @brief json格式的post请求.
 *
 *  @param url              请求的url地址.
 *  @param params           请求的参数.
 *  @param successBlock          请求成功的回调.
 *  @param errorBlock            请求失败的回调.
 *
 *  @return 请求对象.
 */

- (EHRequest *) sendJSONPostRequestWithURL:(NSString *) url
                                    params:(NSDictionary *) params
                                   success:(EHSuccessBlock) successBlock
                                     error:(EHErrorBlock) errorBlock ;

/**
 *  @brief Delete请求.
 *
 *  @param url              请求的url地址.
 *  @param params           请求的参数.
 *  @param successBlock          请求成功的回调.
 *  @param errorBlock            请求失败的回调.
 *
 *  @return 请求对象.
 */

- (EHRequest *) sendDeleteRequestWithURL:(NSString *) url
                                    params:(NSDictionary *) params
                                   success:(EHSuccessBlock) successBlock
                                     error:(EHErrorBlock) errorBlock ;

/**
 *  @brief put请求.
 *
 *  @param url              请求的url地址.
 *  @param params           请求的参数.
 *  @param successBlock          请求成功的回调.
 *  @param errorBlock            请求失败的回调.
 *
 *  @return 请求对象.
 */

- (EHRequest *) sendPutRequestWithURL:(NSString *) url
                                  params:(NSDictionary *) params
                                 success:(EHSuccessBlock) successBlock
                                   error:(EHErrorBlock) errorBlock ;

- (EHRequest *)sendJSONPutRequestWithURL:(NSString *)url
                                  params:(NSDictionary *)params
                                 success:(EHSuccessBlock)successBlock
                                   error:(EHErrorBlock)errorBlock;


@end
