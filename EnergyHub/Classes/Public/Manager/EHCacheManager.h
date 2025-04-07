//
//  EHCacheManager.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/13.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString *kHomeDataKey;
extern const NSString *kHomeBannerKey;

#define EHCourseListKey(aid) [NSString stringWithFormat:@"CourseList_%@", aid]
#define EHCourseMenuListKey(cid) [NSString stringWithFormat:@"CourseMenuList_%@", cid]
#define EHCourseDetailKey(cid) [NSString stringWithFormat:@"CourseDetail_%@", cid]
#define EHCourseMoneyKey(cid) [NSString stringWithFormat:@"CourseMoney_%@", cid]

@interface EHCacheManager : NSObject

/* 获取缓存对象 */
+ (id)objectForCachedKey:(NSString *)key;
/* 是否已经缓存 */
+ (BOOL)hasObjectForCachedKey:(NSString *)key;
/* 缓存对象 */
+ (void)cacheObject:(id<NSCoding>)object forKey:(NSString *)key;
/* 删除缓存对象 */
+ (void)removeObjectForKey:(NSString *)key;
/* 获取所有的缓存对象: 针对离线缓存 */
+ (void)fetchCachedObjectsWithBlock:(void (^)(NSArray *))block;

/* 获取指定的缓存对象 */
+ (void)fetchObjectsWithKeyPrefix:(NSString *)prefix
            completionBlock:(void (^)(NSArray *))block;

@end
