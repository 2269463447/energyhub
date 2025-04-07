//
//  EHGiftView.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/19.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//  打赏

#import "EHGiftView.h"

#define kButtonH 50
#define kButtonW ((kScreenWidth - 40) / 3)
#define kContainerH   260
#define kContainerTag 1190

@interface EHGiftView ()

@property (nonatomic, copy) void(^giftBlock)(NSInteger);

@end

@implementation EHGiftView


+ (instancetype)giftViewWithBlock:(void (^)(NSInteger))block {
    
    EHGiftView *giftView = [[self alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    giftView.giftBlock = block;
    return giftView;
}


- (void)show {
    
    UIView *container = [self viewWithTag:kContainerTag];
    container.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.2 animations:^{
        container.transform = CGAffineTransformIdentity;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    self.backgroundColor = RGBAColor(90, 90, 90, .4);
    CGFloat containerY = (kScreenHeight - kContainerH - 90);
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, containerY, kScreenWidth, kContainerH)];
    container.layer.cornerRadius = 10.f;
    container.backgroundColor = EHPopperColor;
    [self addSubview:container];
    CGFloat giftX = (kScreenWidth - 60) * .5;
    UIImageView *gift = [[UIImageView alloc]initWithFrame:CGRectMake(giftX, -30, 60, 60)];
    gift.backgroundColor = EHPopperColor;
    gift.image = [UIImage imageNamed:@"gift"];
    gift.layer.cornerRadius = 30.f;
    gift.layer.masksToBounds = YES;
    [container addSubview:gift];
    NSArray *titles = @[@"20", @"50", @"100", @"200", @"580", @"2880"];
    // 金额按钮
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *btnTitle = titles[i];
        UIButton *moneyButton = [self createMoneyButtonWithTitle:btnTitle atIndex:i];
        moneyButton.tag = [btnTitle integerValue];
        [container addSubview:moneyButton];
    }
    // 取消
    CGFloat actionBtnY = 90 + (kButtonH + 5) * 2;
    CGFloat actionBtnW = 120;/*(kScreenWidth - 30) * .5*/;
    CGFloat actionBtnX = (kScreenWidth - actionBtnW) * .5;
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(actionBtnX, actionBtnY, actionBtnW, 40);
    [actionBtn setBackgroundColor:EHMainColor];
    [actionBtn setTitle:@"取消" forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(closeGiftView:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:actionBtn];
}

- (void)moneyButtonClicked:(UIButton *)sender {
    
    [self closeGiftView:sender];
    
    !_giftBlock ?: _giftBlock(sender.tag);
}

- (void)closeGiftView:(UIButton *)sender {
    
    UIView *container = [self viewWithTag:kContainerTag];
    [UIView animateWithDuration:0.2 animations:^{
        container.transform = CGAffineTransformMakeScale(0.2, 0.2);
    } completion:^(BOOL finished) {
        [self remove] ;
    }] ;
}

- (void)remove {
    
    [self removeFromSuperview];
}

- (UIButton *)createMoneyButtonWithTitle:(NSString *)title atIndex:(NSInteger)index {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.x = 15 + (kButtonW + 5) * (index % 3);
    btn.y = 60 + (kButtonH + 5) * (index / 3);
    btn.width = kButtonW;
    btn.height = kButtonH;
    [btn setTitle:[NSString stringWithFormat:@"%@U币", title] forState:UIControlStateNormal];
    [btn setTitleColor:EHFontColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    btn.backgroundColor = EHPopperColor;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = .5f;
    btn.layer.cornerRadius = 5.f;
    [btn addTarget:self action:@selector(moneyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //btn.tag = index;
    return btn;
}

@end
