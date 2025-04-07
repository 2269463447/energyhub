//
//  EHBeATeacherToolsView.h
//  EnergyHub
//
//  Created by cpf on 2017/8/31.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHBeATeacherToolsView;
@protocol EHBeATeacherToolsViewDelegate <NSObject>

- (void)didSelectView:(EHBeATeacherToolsView *)toolsView index:(NSInteger)index;

@end

@interface EHBeATeacherToolsView : UIView

@property (nonatomic, weak) id<EHBeATeacherToolsViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame
               withTitleArray:(NSArray *)titleArray;

- (void)updateStatusAtIndex:(NSInteger)index;

@end
