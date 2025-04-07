//
//  EHCourseTitleCell.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/26.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHCourseListData;

@interface EHCourseTitleHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) EHCourseListData *dataModel;

+ (CGFloat)cellHeight;

@end
