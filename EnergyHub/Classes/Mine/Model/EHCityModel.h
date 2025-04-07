//
//  EHCityModel.h
//  EnergyHub
//
//  Created by cpf on 2017/8/29.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EHAreaModel;
@interface EHCityModel : NSObject

@property (nonatomic, copy) NSString *n;

@property (nonatomic, strong) NSArray <EHAreaModel *> *a;

@end
