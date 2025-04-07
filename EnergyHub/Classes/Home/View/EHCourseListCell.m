//
//  EHCourseListCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/21.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHCourseListCell.h"
#import "UIImageView+LoadImage.h"
#import "EHCourseItem.h"

@interface EHCourseListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseIntroduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseGoalLabel;

@end

@implementation EHCourseListCell


+ (CGFloat)cellHeight {
    
    return 100.f;
}

- (void)setItemData:(EHCourseItem *)itemData {
    _itemData = itemData;
    [self.courseImageView loadImageWithRelativeURL:itemData.pic];
    self.courseNameLabel.text = [NSString stringWithFormat:@"课程名称：%@", itemData.name];
    self.courseIntroduceLabel.text = [NSString stringWithFormat:@"简介：%@", itemData.desci];
    self.courseGoalLabel.text = [NSString stringWithFormat:@"学完后：%@", itemData.learnover];
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
