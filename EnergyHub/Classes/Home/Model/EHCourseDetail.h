//
//  EHCourseDetail.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/27.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseDataModel.h"

@interface EHCourseDetail : EHBaseDataModel<NSCoding>

@property (nonatomic, copy) NSString *NAME;
@property (nonatomic, copy) NSString *chap;
@property (nonatomic, copy) NSString *teacher;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *detail;

@end
