//
//  EHWebViewController.h
//  EnergyHub
//
//  Created by cpf on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHWebViewController : UIViewController

/**
 加载本地资源文件

 @param source 文件名
 @param type 文件后缀  eg：html
 @return self
 */
- (instancetype)initWithSource:(NSString *)source ofType:(NSString *)type;

@end
