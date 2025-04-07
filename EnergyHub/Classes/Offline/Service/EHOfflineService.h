//
//  EHOfflineService.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/26.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseService.h"
#import "EHDownloadManager.h"
#import "EHOfflineData.h"

@interface EHOfflineService : EHBaseService

/*
 * 加载本地缓存
 */

- (void)loadOfflineCourseWithBlock:(void (^)(NSArray *))successBlock;

/*
 * 下载课程
 */
- (void)downloadCourseWithParam:(NSDictionary *)param
                   successBlock:(void (^)(EHOfflineData *offlineData))successBlock
                     errorBlock:(EHErrorBlock)errorBlock;

@end
