//
//  EHOfflineViewController.h
//  EnergyHub
//
//  Created by gao on 2017/8/12.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseTableViewController.h"

@interface EHOfflineViewController : EHBaseTableViewController

- (void)downloadCourseWithId:(NSString *)courseId;

@end
