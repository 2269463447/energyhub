//
//  EHPayManagner.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/4.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PayCompletionBlock) (BOOL success, NSString *message);

@interface EHPayManagner : NSObject

+ (instancetype)sharedManager;

- (BOOL)handleOpenURL:(NSURL *)anURL;

/*
 @param: fromController 传入该参数，当微信APP没有安装时会在webview中登录微信
 */

- (void)payWithPayMethod:(PayMethod)method
               orderInfo:(id)orderInfo
         completionBlock:(PayCompletionBlock) completionBlock;



@end
