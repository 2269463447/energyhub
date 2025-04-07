//
//  EHGlobal.h
//  EnergyHub
//
//  Created by gao on 17/8/20.
//  Copyright (c) 2017年 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  全局的单例类(其他在此处初始化)
 */
@interface EHGlobal : NSObject

+ (instancetype) sharedGlobal ;

/*
 * 设置生产模式或者测试模式
 */
//- (void)selectHttpServerMode:(JEServerMode)mode ;

- (NSString *)httpChatServer ;
- (NSString *)httpCommonServer ;
- (NSString *)httpRestServer ;


@end
