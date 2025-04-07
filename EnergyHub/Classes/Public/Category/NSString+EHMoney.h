//
//  NSString+EHMoney.h
//  EnergyHub
//
//  Created by cpf on 2017/9/26.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EHMoney)

/**
 u币转人民币 /10

 @param uMoney u币
 @return 人名币
 */
+ (NSString *)uMoenyChangeToRMBString:(NSString *)uMoney;

/**
 人民币转u币

 @param rmb 人名币
 @return u币
 */
+ (NSString *)rmbChangeToUMoeny:(NSString *)rmb;

/**
 溢价%30

 @param uMoney u币
 @param isHasPoint 是否有小数点
 @return 人名币
 */
+ (NSString *)uMoneyChangeToRiseInPrice:(NSString *)uMoney isHasPoint:(BOOL)isHasPoint;
@end
