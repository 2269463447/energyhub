//
//  EHRechargeRecordCell.m
//  EnergyHub
//
//  Created by cpf on 2018/1/3.
//  Copyright © 2018年 EnergyHub. All rights reserved.
//

#import "EHRechargeRecordCell.h"
#import "EHRechargeRecordModel.h"

@interface EHRechargeRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation EHRechargeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(EHRechargeRecordModel *)model {
    NSInteger money = model.recharge.integerValue;
    NSString * str = [NSString stringWithFormat:@"%@充值%@元兑换%ldU币", model.recdate, model.recharge, money*10];
    self.contentLabel.text = str;
}

@end
