//
//  EHActivityCell.m
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/3/23.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

#import "EHActivityCell.h"
#import "Masonry.h"

@implementation EHActivityCell

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI]; // 设置UI
    }
    return self;
}

// 设置UI
- (void)setupUI {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];  // 设置选中按钮的背景颜色
    self.view.layer.cornerRadius = 5;
    self.view.clipsToBounds = YES;
    self.view.frame = self.contentView.bounds;
    self.view.userInteractionEnabled = NO;
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor colorWithHexString:@"#333333"];
    self.label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(6);
        make.right.equalTo(self.view).offset(-6);
        make.centerY.equalTo(self.view);
    }];
    [self addSubview:self.view];
}

@end
