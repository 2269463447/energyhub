//
//  EHRecordHeaderCell.h
//  EnergyHub
//
//  Created by cpf on 2017/9/4.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHRecordHeaderCell;
@protocol EHRecordHeaderCellDelegate <NSObject>

- (void)didSelectView:(EHRecordHeaderCell *)view index:(NSInteger)index;

@end
@class EHUserInfo;
@interface EHRecordHeaderCell : UITableViewCell

@property (nonatomic, strong) EHUserInfo *userInfo;

@property (nonatomic, weak) id <EHRecordHeaderCellDelegate> delegate;

@property (nonatomic, strong) NSDictionary *data;

@end
