//
//  EHReleasedCourseCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/10.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHReleasedCourseCell.h"
#import "EHReleasedCourseData.h"
#import "UIImageView+LoadImage.h"


@interface EHReleasedCourseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation EHReleasedCourseCell


+ (CGFloat)cellHeight {
    
    return 95.f;
}

- (void)setDataModel:(EHReleasedCourseData *)dataModel {
    _dataModel = dataModel;
    _courseNameLabel.text = [NSString stringWithFormat:@"课程名称：%@", dataModel.name];
    _playTimesLabel.text = [NSString stringWithFormat:@"累计点播次数：%@次", dataModel.tolvideoview];
    _profitLabel.text = [NSString stringWithFormat:@"累计U币收益：%.0fU币", [dataModel.tolmoney floatValue]];
    _timeLabel.text = [NSString stringWithFormat:@"上传时间：%@", dataModel.uptime];
    [_courseImageView loadImageWithRelativeURL:dataModel.pic];
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
