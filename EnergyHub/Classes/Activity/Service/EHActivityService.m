//
//  EHActivityService.m
//  EnergyHub
//
//  Created by gaojuyan on 2024/6/9.
//  Copyright © 2024 EnergyHub. All rights reserved.
//

#import "EHActivityService.h"

@implementation EHActivityService


- (void)activityListWithParam:(NSDictionary *)param
                 successBlock:(void (^)(NSArray*))successBlock
                   errorBlock:(EHErrorBlock)errorBlock {
    NSString *url = EHHttpRestURL(@"intraCityActivity/queryPassActivity.app");
    [self sendJSONPostRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[ResponseData];
        NSDictionary *list = response[@"list"];
        NSArray *courseArray = [EHActivityItem mj_objectArrayWithKeyValuesArray:list];
        successBlock(courseArray);
    } error:^(EHError *error) {
        errorBlock(error);
    }];
}

- (void)activityDetailWithParam:(NSDictionary *)param 
                   successBlock:(void (^)(EHActivityItem * _Nonnull))successBlock
                     errorBlock:(EHErrorBlock)errorBlock {
    
}

@end
