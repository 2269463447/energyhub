//
//  EHVidoMenuItem.h
//  EnergyHub
//
//  Created by cpf on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseDataModel.h"

@interface EHVidoMenuItem : EHBaseDataModel<NSCoding>

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger videoview;
@property (nonatomic, assign) NSInteger numa;

@property (nonatomic, assign) NSInteger inLine;//播放权限

@end
