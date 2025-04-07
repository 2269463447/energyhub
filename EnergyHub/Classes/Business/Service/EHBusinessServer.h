//
//  EHBusinessServer.h
//  EnergyHub
//
//  Created by cpf on 2017/8/14.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHBaseService.h"

@interface EHBusinessServer : EHBaseService;

/**
 成为股东
 */
- (void)businessAddCompanyDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock;

/**
 商务合作
 */
- (void)businessAddCooperateDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock;

/**
 精英加盟
 */
- (void)eliteJoinDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock;

@end
