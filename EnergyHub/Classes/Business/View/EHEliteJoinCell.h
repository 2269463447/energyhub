//
//  EHEliteJoinCell.h
//  EnergyHub
//
//  Created by cpf on 2017/9/1.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHEliteJoinCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) NSString * title;
- (void)updateStatus;

@end
