//
//  EHVideoMenuCell.m
//  EnergyHub
//
//  Created by cpf on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHVideoMenuCell.h"
#import "EHVidoMenuItem.h"
#import "EHBaseService.h"

@interface EHVideoMenuCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *priceImageView;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;

@end

@implementation EHVideoMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    UIView *selectedBackground = [UIView new];
//    self.backgroundColor = [UIColor whiteColor];
//    selectedBackground.backgroundColor = EHMainColor;
//    self.selectedBackgroundView = selectedBackground;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMenuItem:(EHVidoMenuItem *)menuItem {
    _menuItem = menuItem;
    self.titleLabel.text = menuItem.name;
    
    if (menuItem.inLine == 0) {
        NSURL *imgUrl = [NSURL URLWithString:EHHttpRestURL(menuItem.img)];
        [self.priceImageView sd_setImageWithURL:imgUrl];
    }else {
        [self.priceImageView sd_setImageWithURL:nil];
    }
    
    self.timesLabel.text = [NSString stringWithFormat:@"%ld次点播", menuItem.number + menuItem.videoview + menuItem.numa];
    
//    if (menuItem.price.floatValue > 0.f) {
//        self.priceImageView.hidden = NO;
//    }else{
//        self.priceImageView.hidden = YES;
//    }
}

@end
