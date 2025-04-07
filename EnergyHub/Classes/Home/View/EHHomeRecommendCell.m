//
//  EHHomeRecommendCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHHomeRecommendCell.h"
#import "EHHomeBannerData.h"
#import "UIImageView+LoadImage.h"

@interface EHHomeRecommendCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation EHHomeRecommendCell

+ (CGFloat)cellHeight {
    // 按照31:17的比例计算图片的高度
    CGFloat imageH = (kScreenWidth - 40) * .5 / 1.82353;
    return ceil(imageH) + 54.f;
}

- (void)setBannerData:(EHHomeBannerData *)bannerData {
    _bannerData = bannerData;
    self.titleLabel.text = bannerData.title;
    [self.iconImageView loadImageWithRelativeURL:bannerData.icon];
    [self.imageView1 loadImageWithRelativeURL:bannerData.pfour];
    [self.imageView2 loadImageWithRelativeURL:bannerData.pfive];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
