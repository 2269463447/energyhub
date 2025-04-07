//
//  EHVideoMenuModel.h
//  EnergyHub
//
//  Created by cpf on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseDataModel.h"

@class EHVidoMenuItem;

@interface EHVideoMenuModel : EHBaseDataModel<NSCoding>

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray <EHVidoMenuItem *>* course;

@end
