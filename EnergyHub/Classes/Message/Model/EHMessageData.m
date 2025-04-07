//
//  EHMessageData.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHMessageData.h"

@implementation EHMessageData

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"messageId": @"id"};
}

@end
