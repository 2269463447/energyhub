//
//  UIImage+Extension.h
//  VSJujia
//
//  Created by Caiyanzhi on 15/3/10.
//  Copyright (c) 2015年 Vip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  UIColor转UIImage.
 *
 *  @param color 传入UIColor.
 *
 *  @return UIImage对象.
 */
+ (UIImage *) createImageWithColor:(UIColor*) color ;

/**
 *  UIColor转UIImage.需要传入尺寸
 */
+ (UIImage *) createImageWithColor:(UIColor *)color size:(CGSize)size ;

- (UIImage *) fixOrientation ;

/**
 *  修改图片的颜色
 */
- (UIImage *)imageWithColor:(UIColor *)color ;

- (UIImage *) compressImageWithWidth:(CGFloat) defineWidth ;

/**
 * 根据data或路径创建image
 */

+ (UIImage *)fastImageWithData:(NSData *)data;
+ (UIImage *)fastImageWithContentsOfFile:(NSString *)path;

/**
 * 圆角设置
 */
- (UIImage *)circleImage;

+ (UIImage *)convertViewToImage:(UIView *)view;
@end
