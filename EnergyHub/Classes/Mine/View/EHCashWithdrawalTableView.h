//
//  EHCashWithdrawalTableView.h
//  EnergyHub
//
//  Created by cpf on 2017/9/6.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CashWithdrawBlock)(void);

@interface EHCashWithdrawalTableView : UITableView

@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) CashWithdrawBlock withdrawBlock;

@end
