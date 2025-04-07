//
//  EHProvinceModel.h
//  EnergyHub
//
//  Created by cpf on 2017/8/29.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EHCityModel;
@interface EHProvinceModel : NSObject

@property (nonatomic, copy) NSString *p;

@property (nonatomic, strong) NSArray <EHCityModel *> *c;

@end
