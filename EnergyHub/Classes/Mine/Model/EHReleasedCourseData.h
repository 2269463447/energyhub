//
//  EHReleasedCourseData.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/10.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseDataModel.h"

/*
 "tolmoney":410.0,"name":"英语国际音标","tolvideoview":211,
 "id":1,"pic":"img/teacher_image.png","uptime":"2017-05-01"
 */

@interface EHReleasedCourseData : EHBaseDataModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *uptime;
@property (nonatomic, copy) NSString *tolmoney;// 总收益
@property (nonatomic, copy) NSString *tolvideoview; // 点播次数

@end
