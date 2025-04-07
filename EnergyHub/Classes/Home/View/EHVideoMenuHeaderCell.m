//
//  EHVideoMenuHeaderCell.m
//  EnergyHub
//
//  Created by cpf on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHVideoMenuHeaderCell.h"
#import "EHVideoMenuModel.h"
#import "EHBaseService.h"

@interface EHVideoMenuHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation EHVideoMenuHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMenu:(EHVideoMenuModel *)menu {
    _menu = menu;
    self.titleLabel.text = menu.name;
    NSString * url = EHHttpRestURL(menu.icon);
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:url]];
}

@end
