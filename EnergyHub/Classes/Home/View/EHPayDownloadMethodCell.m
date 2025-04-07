//
//  EHPayDownloadMethodCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/3.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHPayDownloadMethodCell.h"


@interface EHPayDownloadMethodCell ()

@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation EHPayDownloadMethodCell

+ (CGFloat)cellHeight {
    
    return 143.f;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickPayMethodButton:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    sender.backgroundColor = RGBColor(255, 252, 235);
    _selectedButton.selected = NO;
    _selectedButton.backgroundColor = [UIColor whiteColor];
    _selectedButton = sender;
    if ([self.delegate respondsToSelector:@selector(didSelectPayMethod:)]) {
        PayMethod method = sender.tag == 100 ? PayMethodAlipay : PayMethodWeixin;
        [self.delegate didSelectPayMethod:method];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
