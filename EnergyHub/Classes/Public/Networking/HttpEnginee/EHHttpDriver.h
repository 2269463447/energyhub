//
//  EHHttpDriver.h
//  JiaeD2C
//
//  Created by Caiyanzhi on 15/8/22.
//  Copyright (c) 2015年 www.jiae.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRequest.h"


#define EHResponseKey  @"data" // 服务器返回的data字段
#define EHResponseCode @"code"
#define EHResponseMsg  @"errorMessage"
#define EHSuccessCode  @"000000"
#define EHRegisterCode @"666666"
#define EHNOPowerKey   @"999999"

/**
 *  网络请求的驱动类(面向非业务的请求, 一般不直接调用).
 *  对AFNetworking进行请求的封装.
 */
@interface EHHttpDriver : NSObject

@property (nonatomic, strong) NSMutableDictionary *headers ;

/**
 *  @brief 发送一个get请求.
 *
 *  @param url     get请求的url地址.
 *  @param params  请求的参数，封装成NSDictionary对象.
 *  @param headers 请求头信息
 *  @param success 请求成功的回调.
 *  @param failure 请求失败的回调.
 *
 *  @return 请求对象.
 */
+ (EHRequest *) sendGetRequestWithURL:(NSString *) url
                               params:(NSDictionary *) params
                              headers:(NSDictionary *) headers
                              success:(void(^)(id responseObEHct)) success
                              failure:(void (^)(NSError *error)) failure ;


/**
 *  @brief 发送一个Post请求.
 *
 *  @param url     post请求的url地址.
 *  @param params  请求的参数，封装成NSDictionary对象.
 *  @param headers 请求头信息
 *  @param success 请求成功的回调.
 *  @param failure 请求失败的回调.
 *
 *  @return 请求对象.
 */
+ (EHRequest *) sendPostRequestWithURL:(NSString *) url
                                params:(NSDictionary *) params
                               headers:(NSDictionary *) headers
                               success:(void(^)(id responseObEHct)) success
                               failure:(void (^)(NSError *error)) failure ;


/**
 *  @brief json格式的post请求.
 *
 *  @param url              请求的url地址.
 *  @param params           请求的参数.
 *  @param success          请求成功的回调.
 *  @param error            请求失败的回调.
 *
 *  @return 请求对象.
 */

+ (EHRequest *) sendJSONPostRequestWithURL:(NSString *) url
                                    params:(NSDictionary *) params
                                   headers:(NSDictionary *) headers
                                   success:(void(^)(id responseObEHct)) success
                                   failure:(void (^)(NSError *error)) failure ;


/**
 *  @brief 上传文件的post请求.
 *
 *  @param url           请求的url地址.
 *  @param params        请求的参数.
 *  @param headers 请求头信息
 *  @param formDataArray 上传文件的数据.数组对象为VSZFormData对象
 *  @param success       请求成功的回调.
 *  @param failure       请求失败的回调.
 *
 *  @return 请求对象.
 */
+ (EHRequest *) postRequestWithURL:(NSString *)url
                             params:(NSDictionary *)params
                            headers:(NSDictionary *) headers
                      formDataArray:(NSArray *)formDataArray
                           success:(void (^)(id))success
                           failure:(void (^)(NSError *))failure ;

/**
 *  @brief 发送一个Delete请求.
 *
 *  @param url     post请求的url地址.
 *  @param params  请求的参数，封装成NSDictionary对象.
 *  @param headers 请求头信息
 *  @param success 请求成功的回调.
 *  @param failure 请求失败的回调.
 *
 *  @return 请求对象.
 */
+ (EHRequest *) sendDeleteRequestWithURL:(NSString *) url
                                params:(NSDictionary *) params
                               headers:(NSDictionary *) headers
                               success:(void(^)(id responseObEHct)) success
                               failure:(void (^)(NSError *error)) failure ;

/**
 *  @brief 发送一个Put请求.
 *
 *  @param url     put请求的url地址.
 *  @param params  请求的参数，封装成NSDictionary对象.
 *  @param headers 请求头信息
 *  @param success 请求成功的回调.
 *  @param failure 请求失败的回调.
 *
 *  @return 请求对象.
 */
+ (EHRequest *) sendPutRequestWithURL:(NSString *) url
                             useJSON:(BOOL)json
                                params:(NSDictionary *) params
                               headers:(NSDictionary *) headers
                               success:(void(^)(id responseObEHct)) success
                               failure:(void (^)(NSError *error)) failure ;




@end

#pragma mark - 上传文件的类

/**
 *  @brief 封装上传文件的类.
 */
@interface EHFormData : NSObject

/**
 *  文件数据.
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;

@end
