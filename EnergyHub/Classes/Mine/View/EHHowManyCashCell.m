//
//  EHHowManyCashCell.m
//  EnergyHub
//
//  Created by cpf on 2017/9/6.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHHowManyCashCell.h"
#import "EHIncomeDetailsModel.h"
#import "EHCashWithdrawalModel.h"
#import "NSString+EHMoney.h"

@interface EHHowManyCashCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation EHHowManyCashCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCash:(NSString *)cash {
    _cash = cash;
    NSString *money = [NSString uMoenyChangeToRMBString:cash];
    self.titleLabel.text = [NSString stringWithFormat:@"当前可取现:%@元", money];
}

- (void)setIncomeDetail:(EHIncomeDetailsModel *)incomeDetail {
    _incomeDetail = incomeDetail;
    NSString *money = [NSString uMoenyChangeToRMBString:incomeDetail.earnings];
    self.titleLabel.text = [NSString stringWithFormat:@"%@收入了%@元", incomeDetail.name, money];
}

- (void)setCashWithdrawal:(EHCashWithdrawalModel *)cashWithdrawal {
    _cashWithdrawal = cashWithdrawal;
    NSString *money = [NSString uMoenyChangeToRMBString:cashWithdrawal.number];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ 提现 %@元", cashWithdrawal.time, money];
}

@end
