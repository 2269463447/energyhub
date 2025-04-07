//
//  EHHorizontalScrollView.h
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/3/22.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EHHorizontalScrollView : UIView

// 设置数据源
@property (nonatomic, strong) NSArray<NSString *> *activities;
@property (nonatomic, assign) NSInteger selectIndex;

// 点击活动时的回调
@property (nonatomic, copy) void (^activitySelected)(NSString *selectedActivity);

- (instancetype)initWithFrame:(CGRect)frame activities:(NSArray<NSString *> *)activities;


@end

NS_ASSUME_NONNULL_END
