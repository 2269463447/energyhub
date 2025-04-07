//
//  UIImageView+LoadImage.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "UIImageView+LoadImage.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extension.h"
#import "EHGlobal.h"

@implementation UIImageView (LoadImage)

- (void)loadImageWithRelativeURL:(NSString *)urlString {
    if (!urlString || ![urlString isKindOfClass:[NSString class]]) {
        // 主色块
        self.image = [UIImage createImageWithColor:EHMainColor size:self.size];
        return;
    }
    NSString *webUrl = [NSString stringWithFormat:@"%@/%@", [[EHGlobal sharedGlobal] httpRestServer], urlString];
    [self loadImageWithURL:webUrl];
}

- (void) loadImageWithURL:(NSString *) urlString {
    // null, 和空字符串非法
    if (!urlString || ![urlString isKindOfClass:[NSString class]]) {
        // 主色块
        self.image = [UIImage createImageWithColor:EHMainColor size:self.size];
        return;
    }
//    self.backgroundColor = [UIColor whiteColor];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"] ;
    self.contentMode = UIViewContentModeCenter ;
    NSString *imageUrl = urlString;
    
    DefineWeakSelf
    [self sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]
            placeholderImage:placeholderImage
                     options:SDWebImageRetryFailed|SDWebImageLowPriority
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (!error) {
                           weakSelf.contentMode = UIViewContentModeScaleAspectFit ;
                           weakSelf.clipsToBounds = YES ;
                           if (image && cacheType == SDImageCacheTypeNone) {
                               weakSelf.alpha = 0 ;
                               [UIView animateWithDuration:0.33 animations:^{
                                   weakSelf.alpha = 1;
                               } ];
                           }
                       } else {
                           weakSelf.alpha = 1 ;
                       }
                   }] ;
    
}

- (void) loadAvatarImageWithURL:(NSString *)urlString {
    
    __weak typeof(self) weakSelf = self ;
    UIImage *placeholderImage = [UIImage imageNamed:@"background_image"] ;
    [self sd_setImageWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
            placeholderImage:placeholderImage
                     options:SDWebImageRetryFailed|SDWebImageLowPriority
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (!error) {
                           weakSelf.contentMode = UIViewContentModeScaleAspectFill ;
                           weakSelf.clipsToBounds = YES ;
                           if (image && cacheType == SDImageCacheTypeNone) {
                               weakSelf.alpha = 0 ;
                               [UIView animateWithDuration:0.33 animations:^{
                                   weakSelf.alpha = 1;
                               } ];
                           }
                       } else {
                           weakSelf.alpha = 1 ;
                       }
                   }] ;
}

@end
