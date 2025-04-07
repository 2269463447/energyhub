//
//  EHHomeCourseData.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/19.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHBaseDataModel.h"

@interface EHHomeCourseData : EHBaseDataModel<NSCoding>

@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;
// menu 没有更多
@property (nonatomic, assign) BOOL isMenu;

@end
