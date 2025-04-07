//
//  EHAreaSelectView.h
//  EnergyHub
//
//  Created by cpf on 2017/8/28.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EHAreaSelectViewClickBlock)(NSString *title);

@interface EHAreaSelectView : UITableView

@property (nonatomic, copy) EHAreaSelectViewClickBlock clickBlock;

- (void)reloadDataByArray:(NSArray *)array;

@end
