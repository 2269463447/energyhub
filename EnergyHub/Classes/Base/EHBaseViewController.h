//
//  EHBaseViewController.h
//  Energy
//
//  Created by gaojuyan on 16/4/6.
//  Copyright © 2017年 Energy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(EHBase)

+ (instancetype)instance;

- (void)startLoadData;
- (void)refreshData;
- (void)loadDataModel;
- (void)unloadDataModel;

- (void)commonInit;
- (void)doInViewDidLoad;

@end


@interface EHBaseViewController : UIViewController

@property (nonatomic, strong) UIColor *navColor;
@property (nonatomic, assign) BOOL needNav;

- (void)setNavBar;

@end
