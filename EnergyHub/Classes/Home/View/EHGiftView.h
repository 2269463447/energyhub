//
//  EHGiftView.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/19.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHGiftView : UIView

+ (instancetype)giftViewWithBlock:(void(^)(NSInteger))block;

- (void)show;

@end
