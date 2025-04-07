//
//  EHProvinceModel.m
//  EnergyHub
//
//  Created by cpf on 2017/8/29.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHProvinceModel.h"
#import "EHCityModel.h"

@implementation EHProvinceModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"c": [EHCityModel class]};
}

@end
