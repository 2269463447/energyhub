//
//  JESmartButton.m
//  Smart
//
//  Created by sky on 16/4/22.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JESmartButton.h"

@implementation JESmartButton

#pragma mark - init

- (instancetype)initWithStyle:(JESmartButtonLayoutStyle)style{
    if (self = [super init]) {
        [self setupButtonWithStyle:style];
        self.titleLabel.font = [UIFont systemFontOfSize:10] ;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupButtonWithStyle:JESmartButtonLayoutStyleH];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupButtonWithStyle:JESmartButtonLayoutStyleH];
    }
    return self;
}

- (void)setupButtonWithStyle:(JESmartButtonLayoutStyle)style {
    self.subviewLayoutStyle = style;
    self.imageTitleMargin = 0.f;
}

#pragma mark - setter

-(void)setImageTitleMargin:(CGFloat)imageTitleMargin{
    _imageTitleMargin = imageTitleMargin;
    [self setNeedsDisplay];
}

-(void)setSubviewLayoutStyle:(JESmartButtonLayoutStyle)subviewLayoutStyle{
    _subviewLayoutStyle = subviewLayoutStyle;
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 计算frame
    CGFloat sumWidth = CGRectGetWidth(self.imageView.frame) + CGRectGetWidth(self.titleLabel.frame) + self.imageTitleMargin;
    CGFloat sumHeight = CGRectGetHeight(self.imageView.frame) + CGRectGetHeight(self.titleLabel.frame) + self.imageTitleMargin;
    CGFloat buttonWidth = CGRectGetWidth(self.bounds);
    CGFloat buttonHeight = CGRectGetHeight(self.bounds);
    // 调整frame
    CGRect labelFrame = self.titleLabel.frame;
    if (sumWidth > buttonWidth) {
        labelFrame.size.width -= sumWidth - buttonWidth;
    }
    // 默认以水平方向计算
    CGRect imageFrame = self.imageView.frame;
    CGFloat startX = truncf((buttonWidth - sumWidth) * .5);
    CGFloat labelFrameY = truncf((CGRectGetHeight(self.bounds) - CGRectGetHeight(labelFrame)) / 2);
    CGFloat imageFrameY = truncf((CGRectGetHeight(self.bounds) - CGRectGetHeight(imageFrame)) / 2);

    switch (self.subviewLayoutStyle) {
        case JESmartButtonLayoutStyleH:
        {
            if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
                imageFrame.origin = CGPointMake(0, imageFrameY);
                labelFrame.origin = CGPointMake(CGRectGetMaxX(imageFrame) + self.imageTitleMargin, labelFrameY);
                self.titleLabel.textAlignment = NSTextAlignmentLeft;
            }else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight){
                labelFrame.origin = CGPointMake(buttonWidth - CGRectGetWidth(labelFrame), labelFrameY);
                imageFrame.origin = CGPointMake(buttonWidth - CGRectGetMinX(labelFrame) - CGRectGetWidth(imageFrame) - self.imageTitleMargin, imageFrameY);
                self.titleLabel.textAlignment = NSTextAlignmentRight;
            }else {
                imageFrame.origin = CGPointMake(startX, imageFrameY);
                labelFrame.origin = CGPointMake(CGRectGetMaxX(imageFrame) + self.imageTitleMargin, labelFrameY);
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
        }
            break;
            // 文字在左，图片在右
        case JESmartButtonLayoutStyleHR:
        {
            if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
                labelFrame.origin = CGPointMake(0, labelFrameY);
                imageFrame.origin = CGPointMake(CGRectGetMaxX(labelFrame) + self.imageTitleMargin, imageFrameY);
                self.titleLabel.textAlignment = NSTextAlignmentLeft;
            }else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight){
                imageFrame.origin = CGPointMake(buttonWidth - CGRectGetWidth(imageFrame), imageFrameY);
                labelFrame.origin = CGPointMake(buttonWidth - CGRectGetWidth(imageFrame) - CGRectGetWidth(labelFrame) - self.imageTitleMargin, labelFrameY);
                self.titleLabel.textAlignment = NSTextAlignmentRight;
            }else {
                labelFrame.origin = CGPointMake(startX, labelFrameY);
                imageFrame.origin = CGPointMake(CGRectGetMaxX(labelFrame) + self.imageTitleMargin, imageFrameY);
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
        }
            break;
            // 文字在下，图片在上
        case JESmartButtonLayoutStyleV:
        {
            // reposition image
            imageFrameY = truncf((buttonHeight - sumHeight) * .5);
            if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
                imageFrame.origin = CGPointMake(0, imageFrameY);
                self.titleLabel.textAlignment = NSTextAlignmentLeft;
            }else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight){
                imageFrame.origin = CGPointMake((buttonWidth - CGRectGetWidth(imageFrame)), imageFrameY);
                self.titleLabel.textAlignment = NSTextAlignmentRight;
            }else {
                imageFrame.origin = CGPointMake((buttonWidth - CGRectGetWidth(imageFrame)) * .5, imageFrameY);
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
            labelFrame =  CGRectMake(0, CGRectGetMaxY(imageFrame) + self.imageTitleMargin, buttonWidth, CGRectGetHeight(labelFrame));
        }
            break;
        case JESmartButtonLayoutStyleVR:
        {
            labelFrame =  CGRectMake(0, truncf((buttonHeight - sumHeight) * .5), buttonWidth, CGRectGetHeight(labelFrame));
            imageFrameY = CGRectGetMaxY(labelFrame) + self.imageTitleMargin;
            if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
                imageFrame.origin = CGPointMake(0, imageFrameY);
                self.titleLabel.textAlignment = NSTextAlignmentLeft;
            }else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight){
                imageFrame.origin = CGPointMake((buttonWidth - CGRectGetWidth(imageFrame)), imageFrameY);
                self.titleLabel.textAlignment = NSTextAlignmentRight;
            }else {
                imageFrame.origin = CGPointMake((buttonWidth - CGRectGetWidth(imageFrame)) * .5, imageFrameY);
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
        }
            break;
    }
    self.titleLabel.frame = labelFrame;
    self.imageView.frame = imageFrame;
}

@end
