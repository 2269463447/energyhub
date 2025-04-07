//
//  EHOfflineCourseCell.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/15.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseTableViewCell.h"
#import "EHCourseItem.h"


@protocol EHCourseDownloadDelegate <NSObject>

- (void)didClickedRetryButtonWithId:(int)pid;

@end

@interface EHOfflineCourseCell : EHBaseTableViewCell

@property (nonatomic, strong) EHCourseItem *dataModel;
@property (nonatomic, weak) id<EHCourseDownloadDelegate> delegate;

@end
