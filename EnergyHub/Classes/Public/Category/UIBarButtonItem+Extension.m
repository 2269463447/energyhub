//
//  UIBarButtonItem+Extension.m
//  JiaeD2C
//
//  Created by Caiyanzhi on 15/8/19.
//  Copyright (c) 2015年 www.jiae.com. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *) itemWithTitle:(NSString *) title
                             target:(id) target
                             action:(SEL) action {
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action] ;
    return barButtonItem ;
}

+ (UIBarButtonItem *) itemWithImage:(UIImage *) image
                             target:(id)target
                             action:(SEL)action {
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action] ;
    return barButtonItem ;
}

+ (UIBarButtonItem *) itemWithButtonImage:(UIImage *) image
                           highlightImage:(UIImage *) highlightImage
                                   target:(id) target
                                   action:(SEL) action {
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    if (highlightImage) {
        [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    }
    
    // 设置按钮的尺寸为背景图片的尺寸
    button.size = button.currentBackgroundImage.size;
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


+ (UIBarButtonItem *)itemWithNormalImage:(UIImage *)image
                            selecteImage:(UIImage *)selecteImage
                                   frame:(CGRect)frame
                                  target:(id)target
                                  action:(SEL)action {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = frame;
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton setImage:selecteImage forState:UIControlStateSelected];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}


@end
