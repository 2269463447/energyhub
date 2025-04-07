//
//  EHBannerImageCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHBannerImageCell.h"
#import "UIImageView+LoadImage.h"

@interface EHBannerImageCell ()

@property (strong, nonatomic) UIImageView *bannerImageView;

@end


@implementation EHBannerImageCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.bannerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.contentView addSubview:self.bannerImageView];
    [self.bannerImageView setContentMode: UIViewContentModeScaleToFill];
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.bannerImageView loadImageWithRelativeURL:imageUrl];
}

@end
