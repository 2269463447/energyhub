//
//  EHCourseItem.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/21.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHBaseDataModel.h"

@interface EHCourseItem : EHBaseDataModel<NSCoding>

@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desci;
@property (nonatomic, copy) NSString *learnover;
// 是否正在下载：用于处理界面
@property (nonatomic, assign) BOOL downloading;
//是否正在解压
@property (nonatomic, assign) BOOL unzipping;
// 已购买，需要重新下载
@property (nonatomic, assign) BOOL retry;

@end
