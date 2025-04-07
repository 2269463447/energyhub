//
//  EHVideoMenuModel.m
//  EnergyHub
//
//  Created by cpf on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHVideoMenuModel.h"
#import "EHVidoMenuItem.h"

@implementation EHVideoMenuModel


MJExtensionCodingImplementation


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID": @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"course": [EHVidoMenuItem class]};
}
@end
