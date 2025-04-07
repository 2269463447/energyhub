//
//  EHActivityItemCell.h
//  EnergyHub
//
//  Created by gaojuyan on 2024/6/9.
//  Copyright © 2024 EnergyHub. All rights reserved.
//

#import "EHBaseTableViewCell.h"
#import "EHActivityItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface EHActivityItemCell : UITableViewCell

@property(nonatomic, strong) EHActivityItem *itemData;

+ (NSString *)cellIdentifier;

@end

NS_ASSUME_NONNULL_END
