//
//  EHBeATeacherToolsView.m
//  EnergyHub
//
//  Created by cpf on 2017/8/31.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBeATeacherToolsView.h"
#import "UIImage+Color.h"

@implementation EHBeATeacherToolsView

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButtonByTitleArray:titleArray];
    }
    return self;
}

- (void)setupButtonByTitleArray:(NSArray *)titleArray {
    CGFloat space = 10.f;
    CGFloat firstBtnWidth = 100.f;
    CGFloat otherBtnWidth = (kScreenWidth - (titleArray.count + 1)*space - firstBtnWidth)/3;
    CGFloat allBtnWidth = 0.f;
    for (int i = 0; i < titleArray.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage createImageWithColor:RGBColor(193, 193, 193)] forState:UIControlStateDisabled];
        [button setBackgroundImage:[UIImage createImageWithColor:EHMainColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(titleBtnCliclk:) forControlEvents:UIControlEventTouchUpInside];
        button.x = allBtnWidth + space*(i+1);
        button.y = 10;
        if (i == 0) {
            button.width = firstBtnWidth;
            button.enabled = YES;
        }else{
            button.width = otherBtnWidth;
            button.enabled = NO;
        }
        button.height = 30.f;
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        allBtnWidth += button.width;
        button.tag = i;
        [self addSubview:button];
    }
}

- (void)titleBtnCliclk:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(didSelectView:index:)]) {
        [_delegate didSelectView:self index:sender.tag];
    }
}

- (void)updateStatusAtIndex:(NSInteger)index {
    
    UIButton *button = [self viewWithTag:index];
    if (button) {
        button.enabled = YES;
    }
}

@end
