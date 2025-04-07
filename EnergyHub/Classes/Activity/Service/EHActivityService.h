//
//  EHActivityService.h
//  EnergyHub
//
//  Created by gaojuyan on 2024/6/9.
//  Copyright © 2024 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHBaseService.h"
#import "EHActivityItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface EHActivityService : EHBaseService

- (void)activityListWithParam:(NSDictionary *)param
                 successBlock:(void (^)(NSArray*))successBlock
                   errorBlock:(EHErrorBlock)errorBlock;

- (void)activityDetailWithParam:(NSDictionary *)param
                 successBlock:(void (^)(EHActivityItem*))successBlock
                   errorBlock:(EHErrorBlock)errorBlock;

@end

NS_ASSUME_NONNULL_END
