//
//  EHMineHeaderCell.h
//  EnergyHub
//
//  Created by cpf on 2017/8/15.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MineHeaderCellActionBlock)(UIButton * sender);

@interface EHMineHeaderCell : UITableViewCell

@property (nonatomic, copy) MineHeaderCellActionBlock loginBlock;
@property (nonatomic, copy) MineHeaderCellActionBlock avatarBlock;

- (void)loadUserInfo;
- (void)updateUserInfo;

@end
