//
//  NSDictionary+Category.m
//  EnergyHub
//
//  Created by cpf on 2017/9/2.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "NSDictionary+Category.h"

@implementation NSDictionary (Category)

- (NSString *)EHObjectForKey:(NSString *)key {
    NSString * value = [self objectForKey:key];
    if ([value isEqual:[NSNull null]] || value == nil) {
        return @"";
    }else{
        return value;
    }
}

@end
