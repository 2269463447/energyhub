//
//  NSString+EHMoney.m
//  EnergyHub
//
//  Created by cpf on 2017/9/26.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "NSString+EHMoney.h"

@implementation NSString (EHMoney)

+ (NSString *)uMoenyChangeToRMBString:(NSString *)uMoney {
    return [NSString stringWithFormat:@"%.02f", uMoney.floatValue/10.0];
}

+ (NSString *)rmbChangeToUMoeny:(NSString *)rmb {
    return [NSString stringWithFormat:@"%.1f", rmb.floatValue*10.0];
}

+ (NSString *)uMoneyChangeToRiseInPrice:(NSString *)uMoney isHasPoint:(BOOL)isHasPoint {
    CGFloat tmp = uMoney.floatValue/10.0;
    if (isHasPoint) {
        return [NSString stringWithFormat:@"%.1f", tmp + tmp*0.3];
    }else{
        return [NSString stringWithFormat:@"%.f", tmp + tmp*0.3];
    }
}

@end
