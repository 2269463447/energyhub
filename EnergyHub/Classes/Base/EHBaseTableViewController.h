//
//  EHBaseTableViewController.h
//  Energy
//
//  Created by gaojuyan on 16/4/5.
//  Copyright © 2017年 Energy. All rights reserved.
//

#import "EHBaseViewController.h"

@interface EHBaseTableViewController : UITableViewController

+ (instancetype)instance;

@property (nonatomic, assign) BOOL hasMore;

@end
