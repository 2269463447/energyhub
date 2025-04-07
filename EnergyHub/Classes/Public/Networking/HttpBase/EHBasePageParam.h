//
//  EHBasePageParam.h
//  EnergyHub
//
//  Created by gjy on 17/8/13.
//  Copyright © 2017年 www.siyu.com. All rights reserved.
//  分页service的参数基类

#import "EHBaseParam.h"

@interface EHBasePageParam : EHBaseParam

@property (nonatomic, assign) NSInteger pageNo ;
@property (nonatomic, assign) NSInteger pageSize ;

@end
