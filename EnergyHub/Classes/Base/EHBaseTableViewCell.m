//
//  EHBaseTableViewCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/14.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHBaseTableViewCell.h"

@implementation EHBaseTableViewCell


+ (NSString *)cellIdentifier {
    
    return NSStringFromClass(self);
}

+ (CGFloat)cellHeight {
    
    return 40.f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *selectedBackground = [UIView new];
    self.backgroundColor = [UIColor whiteColor];
    selectedBackground.backgroundColor = EHMainColor;
    self.selectedBackgroundView = selectedBackground;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    if (self.highlighted) {
        self.contentView.backgroundColor = EHMainColor;
    } else {
        self.contentView.backgroundColor = kBackgroundColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self setNeedsDisplay];
}

@end
