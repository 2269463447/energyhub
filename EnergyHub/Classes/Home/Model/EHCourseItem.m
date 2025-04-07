//
//  EHCourseItem.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/21.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHCourseItem.h"

@implementation EHCourseItem


MJExtensionCodingImplementation


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"courseId": @"id"};
}

@end
