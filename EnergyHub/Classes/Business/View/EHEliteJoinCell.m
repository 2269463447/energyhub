//
//  EHEliteJoinCell.m
//  EnergyHub
//
//  Created by cpf on 2017/9/1.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHEliteJoinCell.h"

@interface EHEliteJoinCell ()



@end

@implementation EHEliteJoinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.layer.cornerRadius = 5;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.layer.borderColor = EHMainColor.CGColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)updateStatus {
    
    self.titleLabel.layer.borderColor = EHLineColor.CGColor;
}

@end
