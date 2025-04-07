//
//  EHCashCountCell.h
//  EnergyHub
//
//  Created by cpf on 2017/9/6.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EHCashCountCellCommitBtnClick)();
@interface EHCashCountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *countTextField;

@property (nonatomic, copy) EHCashCountCellCommitBtnClick commitBtnClickBlock;
@end
