//
//  Utils.h
//  EnergyHub
//
//  Created by cpf on 2017/8/19.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ALAssetLibraryResultBlock)(NSData *data, NSString *filename);

@interface Utils : NSObject

/**
 网络是否可用
 @return BOOL
 */
+ (BOOL)isReachable;

//计算lable 高度
+ (CGRect)getRectwithString:(NSString *)string withFont:(CGFloat)font withWidth:(CGFloat)width;

/**
 验证邮箱合法

 @param email 邮箱
 @return yes no
 */
+ (BOOL) validateEmail:(NSString *)email;

/**
 验证手机号

 @param mobile 手机号
 @return yes no
 */
+ (BOOL) validateMobile:(NSString *)mobile;


/*
 * 从相册中读取图片数据，转成 NSData
 */
+ (void)readImageDataFromPhotoLibraryWithURL:(NSURL *)imageUrl
                                     success:(ALAssetLibraryResultBlock)resultBlock;

/** 判断图片的格式 */
+ (NSString *)imageTypeForData:(NSData *)data;

/**
 * CFBundleIdentifier
 */
+ (NSString *)bundleId;

/**
 * 当前版本号
 * CFBundleShortVersionString
 */
+ (NSString *)appVersion;

/**
 * 当前build版本号
 * CFBundleVersion
 */
+ (NSString *)buildVersion;

/**
 * 随机的文件名
 */
+ (NSString *)randomFileName;


@end
