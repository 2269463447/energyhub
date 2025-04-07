//
//  EHOfflineCourseCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/15.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHOfflineCourseCell.h"
#import "EHDownloadManager.h"
#import "UIImageView+LoadImage.h"
#import "EHOfflineData.h"


@interface EHOfflineCourseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UIView *infoContainer;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseIntroduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseGoalLabel;
@property (weak, nonatomic) IBOutlet UIView *downloadContainer;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;

@end

@implementation EHOfflineCourseCell


+ (CGFloat)cellHeight {
    
    return 92.f;
}

- (void)setDataModel:(EHCourseItem *)dataModel {
    _dataModel = dataModel;
    // 正在下载或已下载完成
    _infoContainer.hidden = dataModel.downloading;
    _downloadContainer.hidden = !dataModel.downloading;
    [_courseImageView loadImageWithRelativeURL:dataModel.pic];
    if (!dataModel.downloading && !dataModel.retry) {
        _courseNameLabel.text = [NSString stringWithFormat:@"课程名称：%@", dataModel.name];
        _courseIntroduceLabel.text = [NSString stringWithFormat:@"简介：%@", dataModel.desci];
        _courseGoalLabel.text = [NSString stringWithFormat:@"学完后：%@", dataModel.learnover];
    }else {
        _capacityLabel.text = @"0MB/0MB";
        _retryButton.hidden = !dataModel.retry;
        _infoContainer.hidden = YES;
        _downloadContainer.hidden = NO;
    }
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.infoContainer.hidden = YES;
    self.downloadContainer.hidden = NO;
    self.progressView.progress = 0.f;
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = EHMainColor;
    self.selectedBackgroundView = selectedBackground;
    // 监听下载状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadStatusChange:)
                                                 name:EHDownloadNotification
                                               object:nil];
}

- (void)downloadStatusChange:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    
    int pid = [userInfo[EHDownloadInfoProductId] intValue];
    if (pid != [self.dataModel.courseId intValue])
    {
        return;
    }
    self.progressView.progress = [userInfo[EHDownloadInfoProgress] floatValue];
    EHDownloadStatus status = [[EHDownloadManager sharedManager] downloadStatusOfProduct:pid];
    if (status == EHDownloadStatusUnzipped) {
        _dataModel.downloading = NO;
        _dataModel.unzipping = NO;
        _dataModel.retry = NO;
        [self setDataModel:_dataModel];
        // 通知一套课程已经下载完成
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloadItemSuccessNotification object:nil];
    }else if (status == EHDownloadStatusDownloading) {
        _retryButton.hidden = YES;
        _dataModel.unzipping = NO;
        _capacityLabel.text = [NSString stringWithFormat:@"%.1fMB/%.1fMB", [userInfo[EHDownloadInfoWritten] floatValue] / 1024 / 1024, [userInfo[EHDownloadInfoExpected] floatValue] / 1024 / 1024];
    }else if (status == EHDownloadStatusDownloadFailed) {
        if (!_dataModel.retry) {
            _dataModel.retry = YES;
        }
        _dataModel.downloading = NO;
        _dataModel.unzipping = NO;
        _retryButton.hidden = NO;
        _downloadTitleLabel.text = @"下载失败";
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloadItemSuccessNotification object:nil];
    }else if (status == EHDownloadStatusUnzipping) {
        _retryButton.hidden = YES;
        _dataModel.unzipping = YES;
        _downloadTitleLabel.text = @"正在解压";
    }else {
        _retryButton.hidden = YES;
        _dataModel.unzipping = NO;
        _downloadTitleLabel.text = @"正在缓存";
    }
    EHLog(@"download: %@", userInfo);
}

// 下载失败，重新下载
- (IBAction)retryAction:(id)sender {
    
    int pid = [_dataModel.courseId intValue];
    NSURLSessionTask *task = [[EHDownloadManager sharedManager] taskOfProduct:pid];
    if (task) {
        [task resume];
    }else {
        if ([self.delegate respondsToSelector:@selector(didClickedRetryButtonWithId:)]) {
            [self.delegate didClickedRetryButtonWithId:pid];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
