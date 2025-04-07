//
//  EHApplyTeacherViewController.h
//  EnergyHub
//
//  Created by cpf on 2017/8/31.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseViewController.h"

typedef enum : NSUInteger {
    EHShowClassStyle,//申请发布课程
    EHBeTeacherStyle,//申请成为老师
} EHApplyStyle;

@interface EHApplyTeacherViewController : EHBaseViewController

- (instancetype)initWithStyle:(EHApplyStyle)style;

@end
