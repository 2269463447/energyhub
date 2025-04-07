//
//  EHRechargeCell.m
//  EnergyHub
//
//  Created by cpf on 2017/11/16.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHRechargeCell.h"

@interface EHRechargeCell()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *UMoneyLabel;

@end

@implementation EHRechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 3;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1;
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    NSString *rmb = data[@"money"];
    NSString *uMoney = data[@"UMoney"];
    self.moneyLabel.text = [rmb stringByAppendingString:@"元"];
    self.UMoneyLabel.text = [uMoney stringByAppendingString:@"U币"];
}

- (void)changeSelectStatus:(BOOL)status {
    if (status) {
        self.moneyLabel.textColor = EHMainColor;
        self.UMoneyLabel.textColor = EHMainColor;
        self.layer.borderColor = EHMainColor.CGColor;
    }else{
        self.moneyLabel.textColor = [UIColor grayColor];
        self.UMoneyLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        self.layer.borderColor = [UIColor grayColor].CGColor;
    }
}

@end
