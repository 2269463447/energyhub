//
//  EHMessageService.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseService.h"
#import "EHMessageData.h"

@interface EHMessageService : EHBaseService

- (void)messageListWithParam:(NSDictionary *)param
                successBlock:(void (^)(NSArray *))successBlock
                  errorBlock:(EHErrorBlock)errorBlock;

// 标记消息已读
- (void)updateMessageWithParam:(NSDictionary *)param
                successBlock:(void (^)(NSDictionary *))successBlock
                  errorBlock:(EHErrorBlock)errorBlock;

+ (EHRequest *)messageStatusWithParam:(NSDictionary *)param
                  successBlock:(void (^)(NSInteger status))successBlock
                    errorBlock:(EHErrorBlock)errorBlock;


@end
