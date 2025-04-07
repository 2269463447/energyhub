//
//  IAPProductModel.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/11/15.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "IAPProductModel.h"

@implementation IAPProductModel

-(instancetype)init {
    self = [self initWithName:nil elements:@[]];
    if(self != nil)
    {
        
    }
    return self;
}

-(instancetype)initWithName:(NSString *)name elements:(NSArray *)elements
{
    self = [super init];
    if(self != nil)
    {
        _name = [name copy];
        _elements = elements;
    }
    return self;
}

@end
