//
//  JEBaseDataModel.h
//  JiaeD2C
//
//  Created by gaojuyan on 16/5/11.
//  Copyright © 2016年 www.jiae.com. All rights reserved.
//  数据模型基类

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface EHBaseDataModel : NSObject

// 增加字段 用于UI逻辑处理: 多选或单选
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end
