//
//  JEHttpDriver.m
//  JiaeD2C
//
//  Created by Caiyanzhi on 15/8/22.
//  Copyright (c) 2015年 www.jiae.com. All rights reserved.
//

#import "EHHttpDriver.h"
#import "AFHTTPSessionManager.h"
#import "EHBaseParam.h"

@implementation EHHttpDriver

#pragma mark - Public Methods

+ (EHRequest *) sendGetRequestWithURL:(NSString *) url
                               params:(NSDictionary *) params
                              headers:(NSDictionary *) headers
                              success:(void(^)(id responseObject)) success
                              failure:(void (^)(NSError *error)) failure {
    
    // 创建管理者对象
    AFHTTPSessionManager *mgr = [self createManagerWithHeaders:headers] ;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    // 发送get请求
    NSURLSessionDataTask *dataTask = [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        EHLog(@"get url : %@, params : %@\n data : %@", url, params, responseObject) ;
        !success?:success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        EHLog(@"get fail -> url : %@, params : %@, error : %@", url, params, error.description) ;
        /*
        if (!mgr.reachabilityManager.reachable) {
            !failure ?: failure(error);
            return;
        }
         */
        !failure ?: failure(error);
    }];
    return [EHRequest requestWithDataTask:dataTask];
}

+ (EHRequest *) sendPostRequestWithURL:(NSString *) url
                                params:(NSDictionary *) params
                               headers:(NSDictionary *) headers
                               success:(void(^)(id responseObject)) success
                               failure:(void (^)(NSError *error)) failure {
    
    // 创建管理者对象
    AFHTTPSessionManager *mgr = [self createManagerWithHeaders:headers];
    // 将基础参数组装到URL中
    NSString *baseString = [EHBaseParam baseParamString];
    EHLog(@"base params string-> %@", baseString);
    NSString *baseUrl = [NSString stringWithFormat:@"%@?%@", url, baseString];
    // 发送POST请求
    NSURLSessionDataTask *dataTask = [mgr POST:baseUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        EHLog(@"post url : %@, params : %@\n data : %@", url, params, responseObject) ;
        !success?:success(responseObject) ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        EHLog(@"post fail -> url : %@, params : %@, error : %@", url, params, error.description) ;
        !failure ?: failure(error) ;
    }];
    
    return [EHRequest requestWithDataTask:dataTask];
}

+ (EHRequest *) sendJSONPostRequestWithURL:(NSString *) url
                                params:(NSDictionary *) params
                               headers:(NSDictionary *) headers
                               success:(void(^)(id responseObject)) success
                               failure:(void (^)(NSError *error)) failure {
    
    // 创建管理者对象
    AFHTTPSessionManager *mgr = [self createManagerWithHeaders:headers];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer] ;
    // 将基础参数组装到URL中
    NSString *baseString = [EHBaseParam baseParamString];
    EHLog(@"base params string-> %@", baseString);
    NSString *baseUrl = [NSString stringWithFormat:@"%@?%@", url, baseString];
    // 发送POST请求
    NSURLSessionDataTask *dataTask = [mgr POST:baseUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        EHLog(@"json post url : %@, params : %@\n data : %@", url, params, responseObject) ;
        !success?:success(responseObject) ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        EHLog(@"json post fail -> url : %@, params : %@, error : %@", url, params, error.description) ;
        !failure ?: failure(error) ;
    }];
    return [EHRequest requestWithDataTask:dataTask];
}


+ (EHRequest *) postRequestWithURL:(NSString *)url
                            params:(NSDictionary *)params
                           headers:(NSDictionary *) headers
                     formDataArray:(NSArray *)formDataArray
                           success:(void (^)(id))success
                           failure:(void (^)(NSError *))failure {
    
    // 创建管理者对象
    AFHTTPSessionManager *mgr = [self createManagerWithHeaders:headers] ;
    NSString *baseString = [EHBaseParam baseParamString];
    NSString *baseUrl = [NSString stringWithFormat:@"%@?%@", url, baseString];
    // 发送POST请求
    EHLog(@"send post formData request: url-> %@", baseUrl);
    NSURLSessionDataTask *dataTask = [mgr POST:baseUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (EHFormData *updataFormData in formDataArray) {
            [formData appendPartWithFileData:updataFormData.data
                                        name:updataFormData.name
                                    fileName:updataFormData.filename
                                    mimeType:updataFormData.mimeType];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        EHLog(@"form post url : %@, params : %@\n data : %@", url, params, responseObject) ;
        !success?:success(responseObject) ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        EHLog(@"form post url : %@, params : %@, error : %@", url, params, error.description) ;
        !failure ?: failure(error) ;
    }];
    return [EHRequest requestWithDataTask:dataTask] ;
}

+ (EHRequest *)sendDeleteRequestWithURL:(NSString *)url params:(NSDictionary *)params headers:(NSDictionary *)headers success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    // 创建管理者对象
    AFHTTPSessionManager *mgr = [self createManagerWithHeaders:headers] ;
    //mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    // 将基础参数组装到URL中
    NSString *baseString = [EHBaseParam baseParamString];
    NSString *baseUrl = [NSString stringWithFormat:@"%@?%@", url, baseString];
    // 发送Delete请求
    EHLog(@"send delete request: url-> %@", baseUrl);
    NSURLSessionDataTask *dataTask = [mgr DELETE:baseUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        EHLog(@"::DELETE:: request url : %@, params : %@\n data : %@", url, params, responseObject) ;
        !success ?: success(responseObject) ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error) ;
    }];
    return [EHRequest requestWithDataTask:dataTask] ;
}

+ (EHRequest *)sendPutRequestWithURL:(NSString *)url
                             useJSON:(BOOL)json
                              params:(NSDictionary *)params
                             headers:(NSDictionary *)headers
                             success:(void (^)(id))success
                             failure:(void (^)(NSError *))failure {
    // 创建管理者对象
    AFHTTPSessionManager *mgr = [self createManagerWithHeaders:headers] ;
    NSString *baseUrl = url;
    // 将基础参数组装到URL中
    NSString *baseString = [EHBaseParam baseParamString];
    baseUrl = [NSString stringWithFormat:@"%@?%@", url, baseString];
    if (json) {
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    // 发送put请求
    EHLog(@"send put request: url->%@", baseUrl);
    NSURLSessionDataTask *dataTask = [mgr PUT:baseUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        EHLog(@"::PUT:: request url : %@, params : %@\n data : %@", url, params, responseObject) ;
        !success ?: success(responseObject) ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error) ;
    }];
    return [EHRequest requestWithDataTask:dataTask] ;
}

#pragma mark - Private Methods

+ (AFHTTPSessionManager *) createManagerWithHeaders:(NSDictionary *) headers {
    EHLog(@"Begin request.........");
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager] ;
    //mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [mgr.requestSerializer setValue:value forHTTPHeaderField:key] ;
    }] ;
    mgr.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    return mgr ;
}

@end


#pragma mark - 上传文件的类

@implementation EHFormData

@end
