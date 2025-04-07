//
//  EHLoginManager.h
//  EnergyHub
//
//  Created by cpf on 2018/1/27.
//  Copyright © 2018年 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHLoginManager : NSObject

+ (UIViewController *)currentController;
+ (void)presentLoginController;
@end
