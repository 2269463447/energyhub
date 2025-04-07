
//
//  EHCourseDetailView.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/27.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHCourseDetailView.h"
#import "EHCourseDetail.h"

@interface EHCourseDetailView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *teacherLabel;
@property (nonatomic, strong) UILabel *numberlLabel;
@property (nonatomic, strong) UILabel *totalTimelLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation EHCourseDetailView


- (void)setDataModel:(EHCourseDetail *)dataModel {
    _dataModel = dataModel;
    _nameLabel.text = dataModel.NAME;
    _teacherLabel.text = [NSString stringWithFormat:@"老师：%@", dataModel.teacher];
    _numberlLabel.text = [NSString stringWithFormat:@"一共%@节课", dataModel.chap];;
    _totalTimelLabel.text = [NSString stringWithFormat:@"一共%@分钟", dataModel.time];
    _detailLabel.text = dataModel.detail;
    [_detailLabel sizeToFit];
    CGFloat contentH = self.height;
    if (_detailLabel.height + 90 > self.height) {
        contentH = _detailLabel.height + 90 + 15;
        UIView *container = [self viewWithTag:800];
        container.height = _detailLabel.bottom + 15;
    }
    _scrollView.contentSize = CGSizeMake(self.width, contentH);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    self.backgroundColor = kBackgroundColor;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    CGFloat labelW = 120.f, labelH = 30.f;;
    CGFloat labelX = 20, labelY = 10;
    UIView *infoContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    infoContainer.backgroundColor = kBackgroundColor;
    [scrollView addSubview:infoContainer];
    self.nameLabel = [self createLabelOn:NSTextAlignmentLeft];
    self.nameLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    labelX = kScreenWidth - labelW - 20;
    self.numberlLabel = [self createLabelOn:NSTextAlignmentRight];
    self.numberlLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    labelY = self.nameLabel.bottom;
    self.teacherLabel = [self createLabelOn:NSTextAlignmentLeft];
    self.teacherLabel.frame = CGRectMake(20, labelY, labelW, labelH);
    self.totalTimelLabel = [self createLabelOn:NSTextAlignmentRight];
    self.totalTimelLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    [infoContainer addSubview:_nameLabel];
    [infoContainer addSubview:_numberlLabel];
    [infoContainer addSubview:_teacherLabel];
    [infoContainer addSubview:_totalTimelLabel];
    labelY = infoContainer.bottom + 10;
    labelW = kScreenWidth - 40;
    UIView *detailContainer = [[UIView alloc]initWithFrame:CGRectMake(0, labelY, kScreenWidth, self.height - labelY)];
    detailContainer.tag = 800;
    detailContainer.backgroundColor = kBackgroundColor;
    [scrollView addSubview:detailContainer];
    self.detailLabel = [self createLabelOn:NSTextAlignmentLeft];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.frame = CGRectMake(20, 10, labelW, detailContainer.height - 10);
    [detailContainer addSubview:_detailLabel];
}

- (UILabel *)createLabelOn:(NSTextAlignment)alignment {
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = EHFontColor;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = alignment;
    return label;
}

@end
