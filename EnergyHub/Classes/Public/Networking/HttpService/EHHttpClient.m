//
//  EHHttpClient.m
//  JiaeD2C
//
//  Created by Caiyanzhi on 15/8/22.
//  Copyright (c) 2015年 www.jiae.com. All rights reserved.
//

#import "EHHttpClient.h"
#import "EHHttpDriver.h"
#import "EHGlobal.h"
#import "EHLoginManager.h"

static EHHttpClient *sharedInstance = nil ;

@interface EHHttpClient ()

@end

@implementation EHHttpClient

#pragma mark - Public Methods

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EHHttpClient alloc] init] ;
    });
    
    return sharedInstance ;
}

- (EHRequest *) sendGetRequestWithURL:(NSString *) url
                                params:(NSDictionary *) params
                               success:(EHSuccessBlock) successBlock
                                 error:(EHErrorBlock) errorBlock {
    __weak typeof(self) weakSelf = self ;
    return [EHHttpDriver sendGetRequestWithURL:url
                                        params:params
                                       headers:[EHHttpClient configHeadersWithParams:params]
                                       success:^(id responseObject) {
                                           [weakSelf responseSuccessWithObject:responseObject
                                                                  successBlock:successBlock
                                                                    errorBlock:errorBlock] ;
                                       } failure:^(NSError *error) {
                                            NSLog(@"error : %@", error.description) ;
                                            [weakSelf responseFailureWithError:error errorBlock:errorBlock] ;
                                       } ] ;
}


- (EHRequest *) sy_sendGetRequestWithURL:(NSString *) url
                               params:(NSDictionary *) params
                              success:(EHSuccessBlock) successBlock
                                error:(EHErrorBlock) errorBlock {
    __weak typeof(self) weakSelf = self ;
    return [EHHttpDriver sendGetRequestWithURL:url
                                        params:params
                                       headers:[EHHttpClient configHeadersWithParams:params]
                                       success:^(id responseObject) {
//                                           [weakSelf responseSuccessWithObject:responseObject
//                                                                  successBlock:successBlock
                                           //                                                                    errorBlock:errorBlock];
                                           successBlock(responseObject);
                                       } failure:^(NSError *error) {
                                           NSLog(@"error : %@", error.description) ;
                                           [weakSelf responseFailureWithError:error errorBlock:errorBlock] ;
                                       } ] ;
}

- (EHRequest *) sendPostRequestWithURL:(NSString *) url
                                 params:(NSDictionary *) params
                                success:(EHSuccessBlock) successBlock
                                  error:(EHErrorBlock) errorBlock {
    __weak typeof(self) weakSelf = self ;
    return [EHHttpDriver sendPostRequestWithURL:url
                                         params:params
                                        headers:[EHHttpClient configHeadersWithParams:params]
                                        success:^(id responseObject) {
                                            [weakSelf responseSuccessWithObject:responseObject
                                                                   successBlock:successBlock
                                                                     errorBlock:errorBlock] ;
                                        } failure:^(NSError *error) {
                                            [weakSelf responseFailureWithError:error errorBlock:errorBlock] ;
                                        } ] ;
}

- (EHRequest *) sendJSONPostRequestWithURL:(NSString *) url
                                params:(NSDictionary *) params
                               success:(EHSuccessBlock) successBlock
                                 error:(EHErrorBlock) errorBlock {
    __weak typeof(self) weakSelf = self ;
    //TODO : headers-> [EHHttpClient configHeadersWithParams:params]
    //NSDictionary *headers = @{@"Accept": @"application/json", @"Content-Type": @"application/json;charset=utf-8"} ;
    return [EHHttpDriver sendJSONPostRequestWithURL:url
                                         params:params
                                        headers:[EHHttpClient configHeadersWithParams:params]
                                        success:^(id responseObject) {
                                            [weakSelf responseSuccessWithObject:responseObject
                                                                   successBlock:successBlock
                                                                     errorBlock:errorBlock] ;
                                        } failure:^(NSError *error) {
                                            [weakSelf responseFailureWithError:error errorBlock:errorBlock] ;
                                        } ] ;
}


- (EHRequest *) postRequestWithURL:(NSString *) url
                             params:(NSDictionary *) params
                      formDataArray:(NSArray *) formDataArray
                            success:(EHSuccessBlock) successBlock
                              error:(EHErrorBlock) errorBlock  {
    __weak typeof(self) weakSelf = self ;
    return [EHHttpDriver postRequestWithURL:url
                                     params:params
                                    headers:[EHHttpClient configHeadersWithParams:params]
                              formDataArray:formDataArray
                                    success:^(id responseObject) {
                                        [weakSelf responseSuccessWithObject:responseObject
                                                               successBlock:successBlock
                                                                 errorBlock:errorBlock] ;
                                    } failure:^(NSError *error) {
                                        [weakSelf responseFailureWithError:error errorBlock:errorBlock] ;
                                    } ] ;
}

- (EHRequest *)sendDeleteRequestWithURL:(NSString *)url params:(NSDictionary *)params success:(EHSuccessBlock)successBlock error:(EHErrorBlock)errorBlock {
    __weak typeof(self) weakSelf = self ;
    return [EHHttpDriver sendDeleteRequestWithURL:url
                                     params:params
                                    headers:[EHHttpClient configHeadersWithParams:params]
                                    success:^(id responseObject) {
                                        [weakSelf responseSuccessWithObject:responseObject
                                                               successBlock:successBlock
                                                                 errorBlock:errorBlock] ;
                                    } failure:^(NSError *error) {
                                        [weakSelf responseFailureWithError:error errorBlock:errorBlock] ;
                                    } ] ;
}

- (EHRequest *)sendPutRequestWithURL:(NSString *)url params:(NSDictionary *)params success:(EHSuccessBlock)successBlock error:(EHErrorBlock)errorBlock {
    __weak typeof(self) weakSelf = self ;
    return [EHHttpDriver sendPutRequestWithURL:url
                                       useJSON:NO
                                        params:params
                                       headers:[EHHttpClient configHeadersWithParams:params]
                                       success:^(id responseObject) {
                                              [weakSelf responseSuccessWithObject:responseObject
                                                                     successBlock:successBlock
                                                                       errorBlock:errorBlock] ;
                                          } failure:^(NSError *error) {
                                              [weakSelf responseFailureWithError:error errorBlock:errorBlock] ;
                                          } ] ;
}

- (EHRequest *)sendJSONPutRequestWithURL:(NSString *)url params:(NSDictionary *)params success:(EHSuccessBlock)successBlock error:(EHErrorBlock)errorBlock {
    __weak typeof(self) weakSelf = self ;
    return [EHHttpDriver sendPutRequestWithURL:url
                                       useJSON:YES
                                        params:params
                                       headers:[EHHttpClient configHeadersWithParams:params]
                                       success:^(id responseObject) {
                                           [weakSelf responseSuccessWithObject:responseObject
                                                                  successBlock:successBlock
                                                                    errorBlock:errorBlock] ;
                                       } failure:^(NSError *error) {
                                           [weakSelf responseFailureWithError:error errorBlock:errorBlock] ;
                                       } ] ;
}


#pragma mark - Private Methods

+ (NSDictionary *) configHeadersWithParams:(NSDictionary *) params {
    
    return nil ;
}

- (void) responseSuccessWithObject:(id) responseObject
                      successBlock:(EHSuccessBlock) successBlock
                        errorBlock:(EHErrorBlock) errorBlock {
    EHError *error = nil ;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSString *responseCode = [responseObject objectForKey:EHResponseCode];
        if ([responseCode isKindOfClass:[NSNumber class]]) {
            responseCode = [NSString stringWithFormat:@"%@", responseCode];
//            responseObject = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//            [responseObject setObject:responseCode forKey:EHResponseCode];
        }
        if (responseCode) {
            // 还有可能是 666666    服务器这里胡乱定义，可能是任意值，无法适配
//            if ([responseCode isEqualToString:EHRegisterCode]) {
//                responseCode = EHSuccessCode;
//            }
            if ([responseCode isEqualToString:EHSuccessCode]) {
                // 服务器返回成功code
                !successBlock?:successBlock(responseObject) ;
            }else if ([responseCode isEqualToString:@"666666"] && responseObject[EHResponseKey]) {
                
//                [EHLoginManager presentLoginController];
                // 只是针对注册接口，特殊处理
                !successBlock?:successBlock(responseObject) ;
            }else {
                // 服务器未返回正确的code
                if ([responseCode isEqualToString:kTokenInvalidCode]) {
                    [[EHUserInfo sharedUserInfo] logOut];
                }
                NSString *errorMessage = responseObject[EHResponseMsg];
                if (!errorMessage) {
                    // 处理代码未统一的问题
                    errorMessage = responseObject[@"errorMsg"];
                }
                error = [EHError errorWithType:EHAPIError
                                           code:401
                                        message:errorMessage] ;
                EHLog(@"result：code = %@, msg = %@", @(error.code), error.msg) ;
                !errorBlock ?: errorBlock(error) ;
            }
            
        } else {
            /*
            error = [EHError errorWithType:EHOtherError
                                       code:kOtherErrorCode
                                    message:responseObject[EHResponseMsg]] ;
            !errorBlock?:errorBlock(error) ;*/
            // 暂时针对不规范的response来处理
            !successBlock ?: successBlock(responseObject);
        }
        
    } else { // 如果返回的类型不是NSDictionary
        NSString *errorMessage = responseObject[EHResponseMsg];
        if (!errorMessage) {
            errorMessage = responseObject[@"errorMsg"];
        }
        error = [EHError errorWithType:EHOtherError
                                   code:kOtherErrorCode
                                message:errorMessage] ;
        !errorBlock ?: errorBlock(error) ;
    }
}

- (void) responseFailureWithError:(NSError *) failure errorBlock:(EHErrorBlock) errorBlock {
    EHError *error = [EHError errorWithType:EHNetWorkError code:failure.code message:kNetworkError] ;
    EHLog(@"response failure：code = %@, msg = %@", @(error.code), failure.description) ;
    !errorBlock ?: errorBlock(error) ;
}


- (void) sy_responseSuccessWithObject:(id) responseObject
                      successBlock:(EHSuccessBlock) successBlock
                        errorBlock:(EHErrorBlock) errorBlock {
    EHError *error = nil ;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSString *responseCode = [responseObject objectForKey:EHResponseCode];
        if (responseCode) {
            if ([responseCode isKindOfClass:[NSNumber class]]) {
                responseCode = [NSString stringWithFormat:@"%@", responseCode];
            }
            if ([responseCode isEqualToString:EHSuccessCode]) {
                // 服务器返回成功code
                !successBlock?:successBlock(responseObject) ;
            } else { // 服务器未返回200,error
                //NSInteger errorCode = [responseObject[EHResponseCode] integerValue] ;
                if ([responseCode isEqualToString:kTokenInvalidCode]) {
                    [[EHUserInfo sharedUserInfo] logOut];
                }
                NSString *errorMessage = responseObject[EHResponseMsg];
                if (!errorMessage) {
                    // 处理代码未统一的问题
                    errorMessage = responseObject[@"errorMsg"];
                }
                error = [EHError errorWithType:EHAPIError
                                          code:401
                                       message:errorMessage] ;
                EHLog(@"result：code = %@, msg = %@", @(error.code), error.msg) ;
                !errorBlock ?: errorBlock(error) ;
            }
            
        } else {
            /*
             error = [EHError errorWithType:EHOtherError
             code:kOtherErrorCode
             message:responseObject[EHResponseMsg]] ;
             !errorBlock?:errorBlock(error) ;*/
            // 暂时针对不规范的response来处理
            !successBlock ?: successBlock(responseObject);
        }
        
    } else { // 如果返回的类型不是NSDictionary
        NSString *errorMessage = responseObject[EHResponseMsg];
        if (!errorMessage) {
            errorMessage = responseObject[@"errorMsg"];
        }
        error = [EHError errorWithType:EHOtherError
                                  code:kOtherErrorCode
                               message:errorMessage] ;
        !errorBlock ?: errorBlock(error) ;
    }
}

@end
