//
//  JERequest.m
//  JiaeD2C
//
//  Created by Caiyanzhi on 15/8/22.
//  Copyright (c) 2015年 www.jiae.com. All rights reserved.
//

#import "EHRequest.h"

@implementation EHRequest

#pragma mark - Public Methods

+ (instancetype) requestWithOperation:(NSOperation *) operation {
    EHRequest *request = [[EHRequest alloc] init] ;
    request.operation = operation ;
    return request ;
}

+ (instancetype) requestWithDataTask:(NSURLSessionDataTask *) dataTask {
    EHRequest *request = [[EHRequest alloc] init] ;
    request.dataTask = dataTask ;
    return request ;
}

//- (void) cancelRequest {
//    [self.operation cancel], self.operation = nil ;
//}

- (void) cancelRequest {
    [self.dataTask cancel], self.dataTask = nil ;
}

@end
