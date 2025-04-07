//
//  EHOfflineData.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/16.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseDataModel.h"
#import "EHCourseItem.h"
#import "EHVideoMenuModel.h"
#import "EHCourseDetail.h"

@interface EHOfflineData : EHBaseDataModel<NSCoding>

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *strZipPath; // 下载地址
@property (nonatomic, strong) NSArray<EHVideoMenuModel *> *data;
@property (nonatomic, strong) EHCourseDetail *data1; // 课程详情

@end
