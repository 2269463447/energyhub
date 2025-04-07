//
//  EHMineCell.m
//  EnergyHub
//
//  Created by cpf on 2017/8/15.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHMineCell.h"

@interface EHMineCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation EHMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    NSString * title = [data objectForKey:@"title"];
    NSString * imgName = [data objectForKey:@"imgName"];
    self.iconImgView.image = [UIImage imageNamed:imgName];
    self.titleLabel.text = title;
}

@end
