//
//  EHOfflineData.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/16.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHOfflineData.h"

@implementation EHOfflineData


MJExtensionCodingImplementation


+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"data": [EHVideoMenuModel class],
             @"data1": [EHCourseDetail class]};
}


@end
