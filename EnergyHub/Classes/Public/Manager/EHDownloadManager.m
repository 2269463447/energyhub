//
//  EHDownloadManager.m
//  Energy
//
//  Created by sky on 9/11/17.
//  Copyright (c) 2017 Energy. All rights reserved.
//

#import "EHDownloadManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <FCFileManager.h>
#import <SSZipArchive.h>
#import <AFNetworking.h>

#define EHZipFileFolder @"zipFolder"
#define EHMagFileFolder @"magFolder"

const NSInteger kDownloadCountMax = 5;

@interface EHDownloadManager() <SSZipArchiveDelegate>

@property (nonatomic, strong) NSURLSessionConfiguration *downloadConfiguration;
@property (nonatomic, strong) AFHTTPSessionManager *downloadSessionManager;

@property (nonatomic, strong) NSMutableDictionary *statusDic;

@property (nonatomic, strong) dispatch_queue_t fileOpQueue;

@end

@implementation EHDownloadManager

+ (instancetype)sharedManager
{
    static EHDownloadManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[[self class] alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _zipPath = [self _createFolder:EHZipFileFolder];
        _magPath = [self _createFolder:EHMagFileFolder];
        
        _statusDic = [[NSMutableDictionary alloc] init];
        
        _fileOpQueue = dispatch_queue_create("com.energy.fileOp", DISPATCH_QUEUE_SERIAL);
        
        _downloadConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _downloadSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:_downloadConfiguration];
        _downloadConfiguration.HTTPMaximumConnectionsPerHost = kDownloadCountMax;
        NSMutableSet *set = [NSMutableSet setWithObjects:@"application/zip",@"application/octet-stream", nil];
        [set addObjectsFromArray:[_downloadSessionManager.responseSerializer.acceptableContentTypes allObjects]];
        _downloadSessionManager.responseSerializer.acceptableContentTypes = set;
        
        __weak typeof(self) welf = self;
        
        // 下载进度的通知
        [_downloadSessionManager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            
            [welf _postDownloadNotifictionWithProduct:downloadTask.taskDescription.intValue
                                               status:EHDownloadStatusDownloading
                                         bytesWritten:totalBytesWritten
                                        bytesExpected:totalBytesExpectedToWrite
             ];
        }];
        /*
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusReachableViaWWAN)
            {
                [self _cancelAll];
            }
        }];*/
    }
    return self;
}

- (void)downloadProduct:(int)pId withURL:(NSString *)URL
{
    if (pId <= 0 || URL.length <=0)
    {
        return;
    }
    
    BOOL reachMax = NO;
    
    if (_downloadSessionManager.downloadTasks.count >= _downloadConfiguration.HTTPMaximumConnectionsPerHost) {
        reachMax = YES;
    }
    
    // 如果task已经存在 return
    NSURLSessionTask *task = [self taskOfProduct:pId];
    if (task.state == NSURLSessionTaskStateSuspended && !reachMax)
    {
        [task resume];
        return;
    }
    
    if (task != nil)
    {
        return;
    }
    
    // 重置状态
    [self.statusDic removeObjectForKey:@(pId)];
    
    // 设置
    NSString *md5name = [self _cachedFileNameForProduct:pId];

    // 删除旧的文件
    NSString *savePath = [self.zipPath stringByAppendingPathComponent:md5name];
    
    [self removeItemAtPath:savePath];
    
    // 下载
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    task = [self.downloadSessionManager downloadTaskWithRequest:request
                                                  progress:nil
                                                destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        if ([FCFileManager existsItemAtPath:self.zipPath] == NO)
        {
            [self _createFolder:EHZipFileFolder];
        }
        return [NSURL fileURLWithPath:savePath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        // 下载完成的通知
        [self _postDownloadNotifictionWithProduct:pId status:(error==nil?EHDownloadStatusDownloadSuccess:EHDownloadStatusDownloadFailed) progress:1];
        if (!error) {
            [self unzipProduct:pId];
        }else {
            //@"下载失败"
            EHLog(@"下载失败: %@", error);
        }
    }];
    task.taskDescription = [NSString stringWithFormat:@"%d",pId];
    if (reachMax) {
        [task suspend];
    }else {
        [task resume];
    }
}


- (void)unzipProduct:(int)pId
{
    [self _postDownloadNotifictionWithProduct:pId status:EHDownloadStatusUnzipping progress:1];

    NSString *md5name = [self _cachedFileNameForProduct:pId];
    NSString *savePath = [self.zipPath stringByAppendingPathComponent:md5name];

    dispatch_async(self.fileOpQueue, ^{
        @autoreleasepool {
            NSString *unzipFolder = [self.magPath stringByAppendingPathComponent:md5name];
            BOOL success = [SSZipArchive unzipFileAtPath:savePath toDestination:unzipFolder delegate:self];
            if (success)
            {
                [FCFileManager removeItemAtPath:savePath];
                DDLogDebug(@"解压成功");
            }
            else
            {
                DDLogDebug(@"解压失败");
            }
            dispatch_async(dispatch_get_main_queue(), ^{

                if (success)
                {
                    //下载成功
                    DDLogDebug(@"下载成功");
                }
                
                // 解压缩完成的通知
                [self _postDownloadNotifictionWithProduct:pId status:(success?EHDownloadStatusUnzipped:EHDownloadStatusUnzipFailed) progress:1];
                
            });
        }
    });

}

- (void)resumeProduct:(int)pId
{
    NSURLSessionTask *task = [self taskOfProduct:pId];
    if (task.state == NSURLSessionTaskStateSuspended)
    {
        [task resume];
    }
}

- (EHDownloadStatus)downloadStatusOfProduct:(int)pId
{
    if (pId <= 0)
    {
        return EHDownloadStatusNotDownload;
    }
    
    NSString *md5name = [self _cachedFileNameForProduct:pId];
    NSString *magPath = [self.magPath stringByAppendingPathComponent:md5name];

    EHDownloadStatus status = [self.statusDic[@(pId)] intValue];

    if ([FCFileManager existsItemAtPath:magPath] && (self.statusDic[@(pId)]==nil || status == EHDownloadStatusUnzipped))
    {
        return EHDownloadStatusUnzipped;
    }

    return status;
}

- (CGFloat)downloadProgressOfProduct:(int)pId
{
    NSURLSessionTask *task = [self taskOfProduct:pId];
    if (task && task.state == NSURLSessionTaskStateRunning)
    {
        long long received = task.countOfBytesReceived;
        long long total = task.countOfBytesExpectedToReceive;
        CGFloat progress = (double)received/total;

        return MIN(progress,0.99f);
    }
    else
    {
        EHDownloadStatus status = [self downloadStatusOfProduct:pId];
        if (status == EHDownloadStatusDownloadSuccess || status == EHDownloadStatusUnzipping)
        {
            return 0.99f;
        }
        else if (status == EHDownloadStatusUnzipped)
        {
            return 1.0f;
        }
    }
    return 0.0f;
}

- (NSURLSessionTask *)taskOfProduct:(int)pId
{
    NSArray *tasks = self.downloadSessionManager.downloadTasks;
    
    for (NSURLSessionTask *task in tasks)
    {
        if (task.taskDescription.intValue == pId)
        {
            return task;
        }
    }
    return nil;
}

- (void)removeAllZip
{
    dispatch_sync(self.fileOpQueue, ^{
//        NSArray *fileList = [FCFileManager listFilesInDirectoryAtPath:self.zipPath];
//        for (NSString *file in fileList)
//        {
//            DDLogDebug(@"%@",file);
//        }
        
        [FCFileManager removeItemsInDirectoryAtPath:self.zipPath];

    });
}

- (void)removeOfProduct:(int)pId
{
    NSString *md5name = [self _cachedFileNameForProduct:pId];
    NSString *magPath = [self.magPath stringByAppendingPathComponent:md5name];
    [self removeItemAtPath:magPath];
    
    [self.statusDic removeObjectForKey:@(pId)];
}

- (NSString *)unzipPathOfProduct:(int)pId
{
    NSString *md5name = [self _cachedFileNameForProduct:pId];
    NSString *magPath = [self.magPath stringByAppendingPathComponent:md5name];

    return magPath;
}

#pragma mark - private

- (void)_postDownloadNotifictionWithProduct:(int)pId
                                     status:(EHDownloadStatus)aStatus
                                   progress:(CGFloat)aProgress {
    
    [self _postDownloadNotifictionWithProduct:pId
                                      status:aStatus
                                 bytesWritten:1.0f
                                bytesExpected:1.0];
}

- (void)_postDownloadNotifictionWithProduct:(int)pId
                                     status:(EHDownloadStatus)aStatus
                               bytesWritten:(CGFloat)written
                              bytesExpected:(CGFloat)expected
{
    self.statusDic[@(pId)] = @(aStatus);
    
    CGFloat aProgress = (double)written / expected;
    
    if (aStatus == EHDownloadStatusDownloading) {
        aProgress = MIN(0.99f, aProgress);
    }
    else if (aStatus == EHDownloadStatusDownloadSuccess || aStatus == EHDownloadStatusUnzipping) {
        aProgress = 0.99f;
    }
    else if (aStatus == EHDownloadStatusUnzipped) {
        aProgress = 1.0f;
    }
    
    @autoreleasepool {
        // 主线程下载发送状态更新的通知
        NSDictionary *downloadInfo = @{EHDownloadInfoProductId: @(pId),
                                       EHDownloadInfoStatus: @(aStatus),
                                       EHDownloadInfoWritten: @(written),
                                       EHDownloadInfoExpected: @(expected),
                                       EHDownloadInfoProgress: @(aProgress)};
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:EHDownloadNotification
                                                                object:nil
                                                              userInfo:downloadInfo];
        });
    }
}

- (NSString *)_createFolder:(NSString *)aFolder
{
    NSString *path = [[FCFileManager pathForLibraryDirectory] stringByAppendingPathComponent:aFolder];
    if ([FCFileManager createDirectoriesForPath:path])
    {
        return path;
    }
    
    return nil;
}

- (void)removeItemAtPath:(NSString *)aPath
{
    dispatch_sync(self.fileOpQueue, ^{
        [FCFileManager removeItemAtPath:aPath];
    });
}

- (NSString *)_cachedFileNameForProduct:(int)pId {
    const char *str = [[NSString stringWithFormat:@"%d",pId] UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}


- (void)_cancelAll
{
    NSArray *taskArray = _downloadSessionManager.downloadTasks;
    for(NSURLSessionTask *task in taskArray)
    {
        [task cancel];
    }
}


@end

