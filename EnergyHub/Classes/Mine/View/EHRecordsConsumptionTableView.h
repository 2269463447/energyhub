//
//  EHRecordsConsumptionTableView.h
//  EnergyHub
//
//  Created by cpf on 2017/9/5.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EHRecoresStyleCost,//消费
//    EHRecoresStyleCashWithdrawal,//提现
    EHRecoresStyleRevenue,//收入
} EHRecoresStyle;

@interface EHRecordsConsumptionTableView : UITableView

@property (nonatomic, assign) EHRecoresStyle recoresStyle;

- (void)setupDataByArray:(NSArray *)array;

@end
