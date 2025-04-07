
//
//  EHCourseTitleCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/26.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHCourseTitleHeader.h"
#import "UIImageView+LoadImage.h"
#import "EHCourseListData.h"

const CGFloat iconW = 22.f;

@interface EHCourseTitleHeader ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation EHCourseTitleHeader

/*
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [EHLineColor setStroke];
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 0, 30);
    CGContextAddLineToPoint(context, 288, 30);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
}*/

+ (CGFloat)cellHeight {
    
    return 44.f;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = kBackgroundColor;
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, iconW, iconW)];
    CGFloat labelX = self.iconImageView.right + 5;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelX, 0, kScreenWidth - labelX - 10, iconW)];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.centerY = 20;self.iconImageView.centerY = 20;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, .5f)];
    line.backgroundColor = EHSeparatorColor;
    [self.contentView addSubview:line];
}

- (void)setDataModel:(EHCourseListData *)dataModel {
    _dataModel = dataModel;
    
    [self.iconImageView loadImageWithRelativeURL:dataModel.icon];
    self.nameLabel.text = dataModel.name;
}

@end
