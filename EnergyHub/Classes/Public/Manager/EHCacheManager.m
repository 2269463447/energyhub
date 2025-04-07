//
//  EHCacheManager.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/13.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHCacheManager.h"
#import <PINCache.h>

const NSString *kHomeDataKey   = @"EHHomeDataKey";
const NSString *kHomeBannerKey = @"EHHomeBannerKey";


@implementation EHCacheManager

+ (void)cacheObject:(id<NSCoding>)object forKey:(NSString *)key {
    
    [[PINCache sharedCache] setObject:object forKey:key];
}

+ (BOOL)hasObjectForCachedKey:(NSString *)key {
    
    return [[PINCache sharedCache] containsObjectForKey:key];
}

+ (id)objectForCachedKey:(NSString *)key  {
    
    return [[PINCache sharedCache] objectForKey:key];
}

+ (void) removeObjectForKey:(NSString *)key {
    
    return [[PINCache sharedCache] removeObjectForKey:key];
}

+ (void)fetchCachedObjectsWithBlock:(void (^)(NSArray *))block {
    // block 必须有
    NSAssert(block, @"block missing!");
    // offline courseb
    NSMutableArray *diskCacheArray = [NSMutableArray array];
    // 获取key，播放的时候再获取value
    [[PINCache sharedCache].diskCache enumerateObjectsWithBlock:^(PINDiskCache * _Nonnull cache, NSString * _Nonnull key, id<NSCoding>  _Nullable object, NSURL * _Nullable fileURL) {
        EHLog(@"key: %@, object: %@, fileURL: %@", key, object, fileURL);
        if (key && [key hasPrefix:@"offline"]) {
            //id<NSCoding> value = [[PINCache sharedCache] objectForKey:key];
            [diskCacheArray addObject:key];
        }
    } completionBlock:^(PINDiskCache * _Nonnull cache) {
        EHLog(@"fetch cached objects complete! count: %@", @(diskCacheArray.count));
        dispatch_async(dispatch_get_main_queue(), ^{
            block(diskCacheArray);
        });
    }];
}

+ (void)fetchObjectsWithKeyPrefix:(NSString *)prefix completionBlock:(void (^)(NSArray *))block {
    NSAssert(prefix, @"prefix key is missing!");
    NSAssert(block, @"block is missing!");
    // key
    NSMutableArray *diskCacheArray = [NSMutableArray array];
    // 获取key，播放的时候再获取value
    [[PINCache sharedCache].diskCache enumerateObjectsWithBlock:^(PINDiskCache * _Nonnull cache, NSString * _Nonnull key, id<NSCoding>  _Nullable object, NSURL * _Nullable fileURL) {
        EHLog(@"key: %@, object: %@, fileURL: %@", key, object, fileURL);
        if (key && [key hasPrefix:prefix]) {
            //id<NSCoding> value = [[PINCache sharedCache] objectForKey:key];
            [diskCacheArray addObject:key];
        }
    } completionBlock:^(PINDiskCache * _Nonnull cache) {
        EHLog(@"fetch cached key objects complete! count: %@", @(diskCacheArray.count));
        dispatch_async(dispatch_get_main_queue(), ^{
            block(diskCacheArray);
        });
    }];
}

@end
