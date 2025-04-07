//
//  UIColor+Hex.h
//  EnergyHub
//
//  Created by cpf on 2017/8/13.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor *)colorWithHexString:(NSString *)hex;
+ (UIColor *)colorWithHexString:(NSString *)hex alpha: (CGFloat)alpha;
@end
