//
//  EHCourseDownloadView.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/3.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHCourseDownloadView.h"


@interface EHCourseDownloadView ()

@property (nonatomic, strong) UILabel *moneyLabel;

@end


@implementation EHCourseDownloadView

- (void)setCost:(NSString *)cost {
    _cost = cost;
    if (!cost) {
        self.moneyLabel.text = @"";
    }else {
        // 返回的价格数据是人民币，改成U币，并涨30%
        NSString *value = [NSString stringWithFormat:@"%.0f", cost.floatValue * 13];
        self.moneyLabel.text = [NSString stringWithFormat:@"本课程离线服务为增值服务，支付%@U币，便可获得本套教材全部课程的下载", value];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    self.backgroundColor = kBackgroundColor;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.backgroundColor = kBackgroundColor;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    CGFloat labelW = self.width - 40, labelH = 34.f;
    CGFloat labelX = 20, labelY = 10;
    UIView *infoContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
    infoContainer.backgroundColor = kBackgroundColor;
    [scrollView addSubview:infoContainer];
    UILabel *titleLabel = [self createLabelOn:NSTextAlignmentLeft];
    titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    titleLabel.text = @"注：缓存服务为付费服务";
    labelY = titleLabel.bottom + 5;
    _moneyLabel = [self createLabelOn:NSTextAlignmentLeft];
    _moneyLabel.numberOfLines = 0;
    _moneyLabel.frame = CGRectMake(labelX, labelY, labelW, labelH + 10);
    labelY = _moneyLabel.bottom + 5;
    UILabel *infoLabel = [self createLabelOn:NSTextAlignmentLeft];
    infoLabel.frame = CGRectMake(20, labelY, labelW, labelH);
    infoLabel.numberOfLines = 0;
    infoLabel.text = @"购买之后，会提供一次缓存服务，缓存之后，本套课程所有章节都可以在离线状态下观看";
    [infoContainer addSubview:titleLabel];
    [infoContainer addSubview:_moneyLabel];
    [infoContainer addSubview:infoLabel];
    // buy button
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat buttonY = (self.height - infoLabel.bottom) / 4 + infoLabel.bottom;
    buyButton.frame = CGRectMake(35, buttonY, self.width - 70, 44);
    buyButton.backgroundColor = EHMainColor;
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton setTitle:@"购买离线服务" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    buyButton.layer.shadowRadius = 5;
    buyButton.layer.shadowOpacity = 0.6;
    buyButton.layer.shadowOffset = CGSizeMake(0, 3);
    buyButton.layer.shadowColor = [UIColor grayColor].CGColor;
    [infoContainer addSubview:buyButton];
    CGFloat contentH = buyButton.bottom;
    if (contentH > infoContainer.height) {
        contentH += 20;
        infoContainer.height = contentH;
    }else {
        contentH = infoContainer.height;
    }
    scrollView.contentSize = CGSizeMake(self.width, contentH);
}

- (void)downloadAction {
    
    if ([self.delegate respondsToSelector:@selector(didClickedDownloadButton)]) {
        [self.delegate didClickedDownloadButton];
    }
}

- (UILabel *)createLabelOn:(NSTextAlignment)alignment {
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = EHFontColor;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = alignment;
    return label;
}

@end
