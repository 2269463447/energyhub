
//
//  EHHomeCourseCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHHomeCourseCell.h"
#import "UIImageView+LoadImage.h"
#import "EHHomeCourseData.h"

@interface EHHomeCourseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UIView *moreContainer;

@end

@implementation EHHomeCourseCell

+ (CGFloat)cellHeight {
    
    return 60.f;
}

- (void)setCourseData:(EHHomeCourseData *)courseData {
    _courseData = courseData;
    if (courseData.isMenu) {
        self.courseImageView.image = [UIImage imageNamed:courseData.img];
    }else {
        [self.courseImageView loadImageWithRelativeURL:courseData.img];
    }
    self.courseNameLabel.text = courseData.name;
    self.moreContainer.hidden = courseData.isMenu;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.moreContainer.hidden = _courseData.isMenu;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
