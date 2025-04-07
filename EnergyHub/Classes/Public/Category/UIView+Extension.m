//
//  UIView+Extension.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(CGFloat)x {
    return self.frame.origin.x;
}

-(void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGSize)size {
    return self.frame.size;
}

-(void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX {
    
    self.center = CGPointMake(centerX, self.centerY);
}

- (CGFloat)centerX {
    
    return CGRectGetMidX(self.frame);
}

- (void)setCenterY:(CGFloat)centerY {
    
    self.center = CGPointMake(self.centerX, centerY);
}

- (CGFloat)centerY {
    
    return CGRectGetMidY(self.frame);
}

- (CGFloat)right {
    
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)bottom {
    
    return CGRectGetMaxY(self.frame);
}

#pragma mark - clear subviews

- (void)clearSubviews {
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)setCornerWithRadius:(CGFloat)radius corners:(UIRectCorner)corners {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    
    self.layer.mask = maskLayer;  // 应用圆角
}

@end
