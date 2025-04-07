//
//  EHAboutViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/18.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHAboutViewController.h"

@interface EHAboutViewController ()

@end

@implementation EHAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    self.view.backgroundColor = kBackgroundColor;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    CGFloat y = 20.f;
    UILabel *aboutTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, 40)];
    aboutTitleLabel.textAlignment = NSTextAlignmentCenter;
    aboutTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    aboutTitleLabel.text = @"网站简单描述";
    [scrollView addSubview:aboutTitleLabel];
    
    y = aboutTitleLabel.bottom + 10;
    UITextView *aboutTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, kScreenHeight - 150)];
    aboutTextView.showsVerticalScrollIndicator = NO;
    aboutTextView.showsHorizontalScrollIndicator = NO;
    aboutTextView.textAlignment = NSTextAlignmentCenter;
    aboutTextView.font = [UIFont systemFontOfSize:14];
    aboutTextView.backgroundColor = kBackgroundColor;
    aboutTextView.textColor = EHFontColor;
    [scrollView addSubview:aboutTextView];
    
    NSMutableString *about = [[NSMutableString alloc]init];
    //[about appendString:@"网站简单描述\n"];
    [about appendString:@"能量库致力于\n"];
    [about appendString:@"您的业余学习平台,\n"];
    [about appendString:@"为老师提供教育传播的入口\n"];
    [about appendString:@"实现两者共赢的局面！\n"];
    [about appendString:@"让我们的业余时间充分利用起来,\n"];
    [about appendString:@"为自己充电蓄积能量,\n"];
    [about appendString:@"只有学习和充电才能让我们立于不败之地,\n"];
    [about appendString:@"足不出户的学习充电\n"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:14];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:about
                                                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10], NSParagraphStyleAttributeName: paragraphStyle                                                                           }];
    
    aboutTextView.attributedText = attributedText;
    aboutTextView.text = about;
    aboutTextView.editable = NO;
    aboutTextView.selectable = NO;
    aboutTextView.scrollEnabled = NO;
    [aboutTextView sizeToFit];
    aboutTextView.width = kScreenWidth;
    
    y = aboutTextView.bottom + 10;
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, 30)];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.textColor = EHMainColor;
    versionLabel.text = [NSString stringWithFormat:@"当前版本V%@", [Utils appVersion]];
    [scrollView addSubview:versionLabel];
    // copyright
    y = versionLabel.bottom + 5;
    UILabel *copyrightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, 36)];
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.font = [UIFont systemFontOfSize:14];
    copyrightLabel.textColor = EHMainColor;
    copyrightLabel.text = @"版权所有：杭州四域文化创意有限公司";
    [scrollView addSubview:copyrightLabel];
    y = copyrightLabel.bottom + 15;
    scrollView.contentSize = CGSizeMake(kScreenWidth, y);
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
