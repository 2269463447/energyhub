//
//  JESmartButton.h
//  Smart
//
//  Created by sky on 16/4/22.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, JESmartButtonLayoutStyle) {
    /**
     水平布局,和原生UIButton一样,图片在前,标题在后
     */
    JESmartButtonLayoutStyleH,//default
    /**
     水平反向布局,标题在前,图片在后
     */
    JESmartButtonLayoutStyleHR,
    /**
     垂直布局,图片在上,标题在下
     */
    JESmartButtonLayoutStyleV,
    
    /**
     垂直反向布局,标题在上,图片中在下
     */
    JESmartButtonLayoutStyleVR,
};

@interface JESmartButton : UIButton

/**
 按钮内部imageView和titleLabel的布局样式
 */
@property (nonatomic, assign) JESmartButtonLayoutStyle subviewLayoutStyle;

/**
 imageView和titleLabel间距
 */

@property (nonatomic, assign) CGFloat imageTitleMargin;

/**
 便利初始化,可选择其他初始化方式
 */
- (instancetype)initWithStyle:(JESmartButtonLayoutStyle)style;

@end
