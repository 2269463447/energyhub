//
//  EHCashCountCell.m
//  EnergyHub
//
//  Created by cpf on 2017/9/6.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHCashCountCell.h"

@implementation EHCashCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)commitAction:(id)sender {
    [self.countTextField resignFirstResponder];
    if (self.commitBtnClickBlock) {
        self.commitBtnClickBlock();
    }
}

@end
