//
//  UIBarButtonItem+Extension.h
//  JiaeD2C
//
//  Created by Caiyanzhi on 15/8/19.
//  Copyright (c) 2015年 www.jiae.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  通过文字初始化UIBarButtonItem.
 */
+ (UIBarButtonItem *)itemWithTitle:(NSString *) title target:(id) target action:(SEL) action ;

/**
 *  通过图片初始化UIBarButtonItem.
 */
+ (UIBarButtonItem *) itemWithImage:(UIImage *) image target:(id)target action:(SEL)action ;

/**
 *  通过button的图片和高亮图片初始化UIBarButtonItem.
 */
+ (UIBarButtonItem *) itemWithButtonImage:(UIImage *) image
                           highlightImage:(UIImage *) highlightImage
                                   target:(id) target
                                   action:(SEL) action ;

/**
 *  通过button的大小初始化UIBarButtonItem.
 */
+ (UIBarButtonItem *)itemWithNormalImage:(UIImage *)image
                            selecteImage:(UIImage *)selecteImage
                                   frame:(CGRect)frame
                                  target:(id)target
                                  action:(SEL)action;

@end
