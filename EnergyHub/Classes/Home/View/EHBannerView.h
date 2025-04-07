//
//  EHBannerView.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kBannerScale 1.82857
#define kBannerHeight (kScreenWidth / kBannerScale)

@interface EHBannerView : UIView

@property (strong, nonatomic) NSArray *adList;

+ (instancetype) bannerView ;

@end
