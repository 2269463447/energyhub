//
//  EHRechargeCell.h
//  EnergyHub
//
//  Created by cpf on 2017/11/16.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHRechargeCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *data;

- (void)changeSelectStatus:(BOOL)status;

@end
