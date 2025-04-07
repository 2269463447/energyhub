//
//  EHVideoMenuView.h
//  EnergyHub
//
//  Created by cpf on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHVidoMenuItem;

typedef void(^EHVideoMenuViewBlock)(EHVidoMenuItem *menuItem, NSIndexPath *indexPath);

@interface EHVideoMenuView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                      withCid:(NSString *)cid;

@property (nonatomic, copy) EHVideoMenuViewBlock menuBlock;

- (void)loadMenuData:(NSArray *)dataArray;
- (void)reloadData;
- (BOOL)hasCourse;

@end
