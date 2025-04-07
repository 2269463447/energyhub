//
//  EHCityModel.m
//  EnergyHub
//
//  Created by cpf on 2017/8/29.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHCityModel.h"
#import "EHAreaModel.h"

@implementation EHCityModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"a": [EHAreaModel class]};
}

@end
