//
//  EHToolsViewCell.m
//  EnergyHub
//
//  Created by cpf on 2017/8/24.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHToolsViewCell.h"

@interface EHToolsViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation EHToolsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    NSString * title = [data objectForKey:@"title"];
    NSString * imgName = [data objectForKey:@"imgName"];
    self.imgView.image = [UIImage imageNamed:imgName];
    self.titleLabel.text = title;
}

@end
