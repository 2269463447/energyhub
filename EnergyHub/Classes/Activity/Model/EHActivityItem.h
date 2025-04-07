//
//  EHActivityItem.h
//  EnergyHub
//
//  Created by gaojuyan on 2024/6/9.
//  Copyright © 2024 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHActivityTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface EHActivityItem : NSObject

@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *activityName;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *count;
@property(nonatomic, strong) NSString *location;
@property (nonatomic, assign) ActivityTheme theme;
@property (nonatomic, copy) NSArray<NSNumber *> *tags;

@end

NS_ASSUME_NONNULL_END
