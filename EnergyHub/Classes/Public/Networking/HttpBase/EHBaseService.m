//
//  JEBaseService.m
//  EnergyHub
//
//  Created by gjy on 17/8/13.
//  Copyright © 2017年 www.siyu.com. All rights reserved.
//

#import "EHBaseService.h"

#define JEHttps_BaseURL @""

@implementation EHBaseService

#pragma mark - URL

+ (NSString *) apiURLWithURL:(NSString *) api {
    //NSString *httpApiURL = JEHttp_BaseURL ;
    NSString *httpApiURL = [[EHGlobal sharedGlobal] httpCommonServer] ;
    if ([httpApiURL hasSuffix:@"/"]) {
        return [httpApiURL stringByAppendingFormat:@"%@", api] ;
    }
    return [httpApiURL stringByAppendingFormat:@"/%@", api] ;
}

+ (NSString *) apiRestURLWithURL:(NSString *) api {
    //NSString *httpApiURL = JEHttp_BaseRestURL ;
    NSString *httpApiURL = [[EHGlobal sharedGlobal]httpRestServer] ;
    if ([httpApiURL hasSuffix:@"/"]) {
        return [httpApiURL stringByAppendingFormat:@"%@", api] ;
    }
    return [httpApiURL stringByAppendingFormat:@"/%@", api] ;
}


+ (NSString *)chatApiUrlWithContext:(NSString *)context
{
    //NSString *httpApiURL = JEHttp_ChatBaseURL ;
    NSString *httpApiURL = [[EHGlobal sharedGlobal]httpChatServer] ;
    if ([httpApiURL hasSuffix:@"/"]) {
        return [httpApiURL stringByAppendingFormat:@"%@", context] ;
    }
    return [httpApiURL stringByAppendingFormat:@"/%@", context] ;
}

+ (NSString *) httpsApiURLWithURL:(NSString *) httpsApi {
    NSString *httpsApiURL = JEHttps_BaseURL ;
    if ([httpsApiURL hasSuffix:@"/"]) {
        return [httpsApiURL stringByAppendingFormat:@"%@", httpsApi] ;
    }
    return [httpsApiURL stringByAppendingFormat:@"/%@", httpsApi] ;
}

#pragma mark - 实例方法

- (EHRequest *) sendGetRequestWithURL:(NSString *) url
                               params:(id) params
                              success:(EHSuccessBlock) success
                                error:(EHErrorBlock) error {
    NSDictionary *baseParam = [[EHBaseParam param] mj_keyValues];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[params mj_keyValues]];
    if (parameters[@"id"]) {
        [baseParam setValue:nil forKey:@"id"];
    }
    [parameters setValuesForKeysWithDictionary:baseParam];
    /*
    NSMutableDictionary *encodedParameters = [NSMutableDictionary dictionaryWithCapacity:parameters.count];
    for (NSString *key in parameters) {
        NSString *value = [parameters objectForKey:key];
        if ([value isKindOfClass:[value class]]) {
            [encodedParameters setObject:[value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] forKey:key];
        }else {
            [encodedParameters setObject:value forKey:key];
        }
    }*/
    return [[EHHttpClient sharedInstance] sendGetRequestWithURL:url
                                                         params:parameters
                                                        success:success
                                                          error:error] ;
}

- (EHRequest *) sy_sendGetRequestWithURL:(NSString *) url
                               params:(id) params
                              success:(EHSuccessBlock) success
                                error:(EHErrorBlock) error {
    NSDictionary *baseParam = [[EHBaseParam param] mj_keyValues];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[params mj_keyValues]];
    if (parameters[@"id"]) {
        [baseParam setValue:nil forKey:@"id"];
    }
    [parameters setValuesForKeysWithDictionary:baseParam];
    return [[EHHttpClient sharedInstance] sy_sendGetRequestWithURL:url
                                                         params:parameters
                                                        success:success
                                                          error:error] ;
}

- (EHRequest *) sendPostRequestWithURL:(NSString *) url
                                params:(id) params
                               success:(EHSuccessBlock) success
                                 error:(EHErrorBlock) error {
    NSDictionary *paramsDictionary = [params mj_keyValues];
    return [[EHHttpClient sharedInstance] sendPostRequestWithURL:url
                                                          params:paramsDictionary
                                                         success:success
                                                           error:error] ;
}

- (EHRequest *) sendJSONPostRequestWithURL:(NSString *) url
                                params:(id) params
                               success:(EHSuccessBlock) success
                                 error:(EHErrorBlock) error {
    NSDictionary *paramsDictionary = [params mj_keyValues];
    return [[EHHttpClient sharedInstance] sendJSONPostRequestWithURL:url
                                                          params:paramsDictionary
                                                         success:success
                                                           error:error] ;
}

- (EHRequest *) postRequestWithURL:(NSString *) url
                            params:(id) params
                     formDataArray:(NSArray *) formDataArray
                           success:(EHSuccessBlock) success
                             error:(EHErrorBlock) error {
    NSDictionary *paramsDictionary = [params mj_keyValues];
    return [[EHHttpClient sharedInstance] postRequestWithURL:url
                                                      params:paramsDictionary
                                               formDataArray:formDataArray
                                                     success:success
                                                       error:error] ;
}

- (EHRequest *) sendDeleteRequestWithURL:(NSString *) url
                                params:(id) params
                               success:(EHSuccessBlock) success
                                 error:(EHErrorBlock) error {
    EHBaseParam *baseParam = [EHBaseParam param];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[params mj_keyValues]];
    [parameters setValuesForKeysWithDictionary:baseParam.mj_keyValues];
    return [[EHHttpClient sharedInstance] sendDeleteRequestWithURL:url
                                                          params:parameters
                                                         success:success
                                                           error:error] ;
}

- (EHRequest *) sendPutRequestWithURL:(NSString *) url
                                params:(id) params
                               success:(EHSuccessBlock) success
                                 error:(EHErrorBlock) error {
    //SDictionary *paramsDictionary = [params mj_keyValues];
    EHBaseParam *baseParam = [EHBaseParam param];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[params mj_keyValues]];
    [parameters setValuesForKeysWithDictionary:baseParam.mj_keyValues];
    return [[EHHttpClient sharedInstance] sendPutRequestWithURL:url
                                                          params:parameters
                                                         success:success
                                                           error:error] ;
}

- (EHRequest *) sendJSONPutRequestWithURL:(NSString *) url
                               params:(id) params
                              success:(EHSuccessBlock) success
                                error:(EHErrorBlock) error {
    NSDictionary *paramsDictionary = [params mj_keyValues];
    return [[EHHttpClient sharedInstance] sendJSONPutRequestWithURL:url
                                                         params:paramsDictionary
                                                        success:success
                                                          error:error] ;
}


#pragma mark - 类方法

+ (EHRequest *) sendGetRequestWithURL:(NSString *) url
                               params:(id) params
                              success:(EHSuccessBlock) success
                                error:(EHErrorBlock) error {
    NSDictionary *baseParam = [[EHBaseParam param] mj_keyValues];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[params mj_keyValues]];
    if (parameters[@"id"]) {
        [baseParam setValue:nil forKey:@"id"];
    }
    [parameters setValuesForKeysWithDictionary:baseParam];
    return [[EHHttpClient sharedInstance] sendGetRequestWithURL:url
                                                         params:parameters
                                                        success:success
                                                          error:error] ;
}

+ (EHRequest *) sendPostRequestWithURL:(NSString *) url
                                params:(id) params
                               success:(EHSuccessBlock) success
                                 error:(EHErrorBlock) error {
    NSDictionary *baseParam = [[EHBaseParam param] mj_keyValues];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[params mj_keyValues]];
    if (parameters[@"id"]) {
        [baseParam setValue:nil forKey:@"id"];
    }
    [parameters setValuesForKeysWithDictionary:baseParam];
    return [[EHHttpClient sharedInstance] sendPostRequestWithURL:url
                                                          params:parameters
                                                         success:success
                                                           error:error] ;
}

+ (EHRequest *)sendJSONPostRequestWithURL:(NSString *)url params:(id)params success:(EHSuccessBlock)success error:(EHErrorBlock)error {
    NSDictionary *paramsDictionary = [params mj_keyValues];
    return [[EHHttpClient sharedInstance] sendJSONPostRequestWithURL:url
                                                          params:paramsDictionary
                                                         success:success
                                                           error:error] ;
}


+ (EHRequest *) postRequestWithURL:(NSString *) url
                            params:(id) params
                     formDataArray:(NSArray *) formDataArray
                           success:(EHSuccessBlock) success
                             error:(EHErrorBlock) error {
    NSDictionary *paramsDictionary = [params mj_keyValues];
    return [[EHHttpClient sharedInstance] sendGetRequestWithURL:url
                                                        params:paramsDictionary
                                                        success:success
                                                          error:error] ;
}

@end
