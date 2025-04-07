//
//  EHOfflineService.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/26.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHOfflineService.h"
#import "EHCacheManager.h"

@interface EHOfflineService ()

@property (nonatomic, strong) EHRequest *downloadRequest;

@end

@implementation EHOfflineService

- (void)loadOfflineCourseWithBlock:(void (^)(NSArray *))successBlock {
    
    // 本地保存的文件
    [EHCacheManager fetchCachedObjectsWithBlock:^(NSArray *objects) {
        
        NSMutableArray *courseArray = [NSMutableArray array];
        if (objects.count > 0) {
            for (NSString *offlineKey in objects) {
                NSString *cacheKey = [NSString stringWithFormat:@"courseb_%@", [offlineKey substringFromIndex:8]];
                id<NSCoding> cachedObject = [EHCacheManager objectForCachedKey:cacheKey];
                if (cachedObject) {
                    [courseArray addObject:cachedObject];
                }else {
                    EHLog(@"fetch nonexist course item for key: %@", cacheKey);
                }
            }
        }
        successBlock(courseArray);
    }];
}

- (void)downloadCourseWithParam:(NSDictionary *)param
                   successBlock:(void (^)(EHOfflineData *offlineData))successBlock
                     errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"power/downAll.app");
    
    self.downloadRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        if ([responseDictinary[EHResponseCode] isEqualToString:EHSuccessCode]) {
            // 缓存数据
            NSString *cacheKey = [NSString stringWithFormat:@"offline_%@", param[@"tid"]];
            EHOfflineData *cacheData = [EHOfflineData mj_objectWithKeyValues:responseDictinary];
            [EHCacheManager cacheObject:cacheData forKey:cacheKey];
            successBlock(cacheData);
        }else {
            successBlock(nil);
        }
    } error:errorBlock];
}

- (void)dealloc {
    
    [self.downloadRequest cancelRequest];
}


@end
