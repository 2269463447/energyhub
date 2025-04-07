//
//  EHCourseDownloadView.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/3.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EHCourseDownloadDelegate <NSObject>

- (void)didClickedDownloadButton;

@end

@interface EHCourseDownloadView : UIView

@property (nonatomic, copy) NSString *cost;
@property (nonatomic, weak) id<EHCourseDownloadDelegate> delegate;

@end
