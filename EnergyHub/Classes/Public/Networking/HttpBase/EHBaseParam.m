//
//  EHBaseParam.m
//  EnergyHub
//
//  Created by gjy on 17/8/13.
//  Copyright (c) 2017年 www.siyu.com. All rights reserved.
//

#import "EHBaseParam.h"
#import "OpenUDID.h"
#import "EHGlobal.h"
#import "MJExtension.h"

@interface EHBaseParam()

//@property (nonatomic, copy) NSString *deviceOS ;
@property (nonatomic, copy) NSString *machineCode ;
@property (nonatomic, copy) NSString *token ;
@property (nonatomic, copy) NSString *id ;
//@property (nonatomic, copy) NSString *nonce ;
//@property (nonatomic, copy) NSString *sign ;

@end

@implementation EHBaseParam

- (instancetype) init {

    if (self = [super init]) {
        self.machineCode = [OpenUDID value];
        //self.deviceOS = @"I" ;
        self.token = [EHUserInfo sharedUserInfo].token;
        self.id = [EHUserInfo sharedUserInfo].Id;
    }
    return self;
}

+ (instancetype) param {
    return [[self alloc] init] ;
}

+ (NSString *)baseParamString {
    // 将基础参数组装到URL中
    NSDictionary *baseParams = [[self param] mj_keyValues];
    NSMutableString *baseString = [@"" mutableCopy];
    [baseParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [baseString appendFormat:@"%@=%@", key, value];
        if (baseString.length > 1) {
            [baseString appendString:@"&"];
        }
    }];
    // 将最后一个&删除
    if ([baseString hasSuffix:@"&"]) {
        [baseString deleteCharactersInRange:NSMakeRange(baseString.length - 1, 1)];
    }
    return baseString;
}

@end
