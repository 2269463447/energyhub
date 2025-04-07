//
//  EHHowManyCashCell.h
//  EnergyHub
//
//  Created by cpf on 2017/9/6.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHIncomeDetailsModel, EHCashWithdrawalModel;
@interface EHHowManyCashCell : UITableViewCell

@property (nonatomic, copy) NSString *cash;

@property (nonatomic, strong) EHIncomeDetailsModel *incomeDetail;

@property (nonatomic, strong) EHCashWithdrawalModel *cashWithdrawal;

@end
