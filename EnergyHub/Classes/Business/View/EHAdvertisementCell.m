//
//  EHAdvertisementCell.m
//  EnergyHub
//
//  Created by cpf on 2017/8/26.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHAdvertisementCell.h"

@interface EHAdvertisementCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation EHAdvertisementCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDict:(NSDictionary *)dict {
    self.titleLabel.text = dict[@"title"];
    self.contentLabel.text = dict[@"content"];
}

@end
