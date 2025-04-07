//
//  EHCourseListData.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/21.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHBaseDataModel.h"
#import "EHCourseItem.h"

@interface EHCourseListData : EHBaseDataModel<NSCoding>

@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<EHCourseItem *> *typecs;

@end
