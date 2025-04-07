//
//  EHPayDownloadCourseInfoCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/3.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHPayDownloadCourseInfoCell.h"

@interface EHPayDownloadCourseInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@end

@implementation EHPayDownloadCourseInfoCell


+ (CGFloat)cellHeight {
    
    return 160.f;
}

- (void)setDataInfo:(NSDictionary *)dataInfo {
    _dataInfo = dataInfo;
    _courseNameLabel.text = [NSString stringWithFormat:@"名称：%@", dataInfo[@"courseName"]];
    _quantityLabel.text = [NSString stringWithFormat:@"数量：%@节视频课程", dataInfo[@"quantity"]];
    _costLabel.text = [NSString stringWithFormat:@"费用：%.0fU币", [dataInfo[@"cost"] floatValue] * 13];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // config text color
    _courseNameLabel.textColor = EHFontColor;
    _quantityLabel.textColor = EHFontColor;
    _costLabel.textColor = EHFontColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
