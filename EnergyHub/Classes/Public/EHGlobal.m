//
//  EHGlobal.h
//  EnergyHub
//
//  Created by gao on 17/8/20.
//  Copyright (c) 2017年 EnergyHub. All rights reserved.
//

#import "EHGlobal.h"

@interface EHGlobal ()

@property (nonatomic, copy)NSString *chatServer ; // 测试或者正式环境
@property (nonatomic, copy)NSString *commonServer ; // 测试或者正式环境
@property (nonatomic, copy)NSString *restServer ; // rest环境

@end

@implementation EHGlobal

#pragma mark - Public Methods

+ (EHGlobal *)sharedGlobal {
    static EHGlobal *global = nil;
    static dispatch_once_t globalToken;
    dispatch_once(&globalToken, ^{
        if (!global) {
            global = [[EHGlobal alloc] init];
        }
    });
    return global;
}

- (void)selectHttpServerMode:(int)mode
{
    
}

- (NSString *)httpCommonServer
{
    return [NSString stringWithFormat:@"%@", self.commonServer] ;
}

- (NSString *)httpChatServer
{
    return [NSString stringWithFormat:@"%@/rest", self.chatServer] ;
}

- (NSString *)httpRestServer {
    return [NSString stringWithFormat:@"%@/app", self.restServer] ;
}

#pragma mark - Life Cycle Methods

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - getters

- (NSString *)commonServer
{
    if (!_commonServer) {
        _commonServer = @"http://www.sycy888.com" ;
//        _commonServer = @"http://129.28.32.247:9001";
    }
    return _commonServer ;
}

- (NSString *)restServer {
    if (!_restServer) {
        _restServer = @"http://www.sycy888.com" ;
//        _restServer = @"http://129.28.32.247:9001"; // for test
    }
    return _restServer ;
}


@end
