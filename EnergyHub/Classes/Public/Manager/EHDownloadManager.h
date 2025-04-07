//
//  EHDownloadManager.h
//  Energy
//
//  Created by sky on 9/11/17.
//  Copyright (c) 2017 Energy. All rights reserved.
//


#import <Foundation/Foundation.h>

#define EHDownloadNotification  @"EHDownloadNotification"
#define EHDownloadInfoProductId @"productId"
#define EHDownloadInfoProgress  @"progress"
#define EHDownloadInfoStatus    @"status"
#define EHDownloadInfoWritten   @"written"
#define EHDownloadInfoExpected  @"expected"


typedef NS_ENUM(NSInteger, EHDownloadStatus) {

    EHDownloadStatusNotDownload = 0,
    EHDownloadStatusDownloading = 1,
    EHDownloadStatusPause = 2,
    EHDownloadStatusDownloadFailed = 3,
    EHDownloadStatusDownloadSuccess = 4,
    EHDownloadStatusUnzipping = 5,
    EHDownloadStatusUnzipped = 6,
    EHDownloadStatusUnzipFailed = 7,
};


@interface EHDownloadManager : NSObject

@property (nonatomic, strong) NSString *magPath;
@property (nonatomic, strong) NSString *zipPath;


+ (instancetype)sharedManager;


/**
 *  下载产品
 *
 *  @param URL 下载地址
 *  @param pId 文件id
 */
- (void)downloadProduct:(int)pId withURL:(NSString *)URL;

///**
// *  暂停下载文件
// *
// *  @param aFile 文件名
// */
//- (void)pauseFile:(NSString *)aFile;
//
/**
 *  解压产品
 *
 *  @param pId 文件id
 */
- (void)unzipProduct:(int)pId;

/**
 *  获取产品下载状态
 *
 *  @param pId 文件id
 *
 *  @return status
 */
- (EHDownloadStatus)downloadStatusOfProduct:(int)pId;

/**
 *  产品的下载进度
 *
 *  @param pId 文件id
 *
 *  @return progress
 */
- (CGFloat)downloadProgressOfProduct:(int)pId;

/**
 *  文件对应的下载任务
 *
 *  @param pId 文件id
 *
 *  @return task
 */
- (NSURLSessionDownloadTask *)taskOfProduct:(int)pId;

/**
 *  删除所有zip包
 */
- (void)removeAllZip;

/**
 *  删除产品
 *
 *  @param pId 文件id
 */
- (void)removeOfProduct:(int)pId;

/**
 *  解压产品
 *
 *  @param pId 文件id
 *
 *  @return 产品解压路径
 */
- (NSString *)unzipPathOfProduct:(int)pId;


@end
