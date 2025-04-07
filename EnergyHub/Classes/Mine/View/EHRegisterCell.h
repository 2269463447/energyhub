//
//  EHRegisterCell.h
//  EnergyHub
//
//  Created by cpf on 2017/8/28.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHRegisterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@property (nonatomic, strong) NSDictionary * dict;

@end
