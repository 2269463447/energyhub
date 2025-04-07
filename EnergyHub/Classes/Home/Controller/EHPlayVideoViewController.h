//
//  EHPlayVideoViewController.h
//  EnergyHub
//
//  Created by cpf on 2017/8/13.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EHPlayType) {
    EHPlayTypeOnline,
    EHPlayTypeOffline
};

@class EHOfflineData;

@interface EHPlayVideoViewController : UIViewController

/**
 二级课程id
 */
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, assign) EHPlayType playType;
@property (nonatomic, strong) EHOfflineData *offlineData;

@end
