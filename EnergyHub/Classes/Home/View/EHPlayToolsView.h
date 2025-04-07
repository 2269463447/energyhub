//
//  EHPlayToolsView.h
//  EnergyHub
//
//  Created by cpf on 2017/8/14.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHPlayToolsView;
@protocol EHPlayToolsViewDelegate <NSObject>

- (void)didSelectView:(EHPlayToolsView *)view index:(NSInteger)index;

@end

@interface EHPlayToolsView : UIView

@property (nonatomic, assign) id<EHPlayToolsViewDelegate>delegate;

@end

