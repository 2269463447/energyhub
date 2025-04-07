//
//  EHStatementViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/19.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHStatementViewController.h"
#import "UIViewController+Share.h"

@interface EHStatementViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation EHStatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    self.view.backgroundColor = kBackgroundColor;
    [self facilitateShare];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight - 64 - 10)];
        _scrollView.backgroundColor = kBackgroundColor;
        [self loadLawView];
    }
    return _scrollView;
}

- (void)loadLawView {
    
    /**
     一、法律声明:
     */
    UILabel * lawLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, _scrollView.width - 20, 20)];
    lawLabel.text = @"一、法律声明:";
    [_scrollView addSubview:lawLabel];
    
    
    UILabel * lawFirstLabel = [[UILabel alloc] init];
    lawFirstLabel.text = @"(1)、我公司所有业务合作均有标准流程，合同签署必须盖章，而不是扫描件；";
    lawFirstLabel.numberOfLines = 0;
    lawFirstLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:lawFirstLabel];
    CGRect firstRect = [Utils getRectwithString:lawFirstLabel.text withFont:15 withWidth:kScreenWidth - 30];
    lawFirstLabel.frame = CGRectMake(15, lawLabel.bottom + 5, _scrollView.width - 30, firstRect.size.height);
    

    UILabel * lawSecondLabel = [[UILabel alloc] init];
    lawSecondLabel.text = @"(2)、能量库平台上的所有课程都是各位老师的原创作品，内容如有涉及到侵权行为，请及时向平台提供书面权利通知，并且提供身份证明、权属证明、具体链接或书面材料、及详细侵权情况说明。平台会追究侵权作品的责任，以及相关后续纠正事务。";
    lawSecondLabel.numberOfLines = 0;

    lawSecondLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:lawSecondLabel];
    CGRect secondRect = [Utils getRectwithString:lawSecondLabel.text withFont:15 withWidth:kScreenWidth - 30];
    lawSecondLabel.frame = CGRectMake(15, lawFirstLabel.bottom + 5, kScreenWidth - 30, secondRect.size.height);

    
    UILabel * lawThirdLabel = [[UILabel alloc] init];
    lawThirdLabel.text = @"(3)、平台上的所有会员在论坛的发言、以及老师的作品，都是会员个人的观点，不代表本平台观点，凡是使用本平台的会员，都要对自己的言论负责。";
    lawThirdLabel.numberOfLines = 0;
    lawThirdLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:lawThirdLabel];
    CGRect thirdRect = [Utils getRectwithString:lawThirdLabel.text withFont:15 withWidth:kScreenWidth - 30];
    lawThirdLabel.frame = CGRectMake(15, lawSecondLabel.bottom + 5, kScreenWidth - 30, thirdRect.size.height);
    
    
    
    /**
     二、知识产权声明:
     */
    UILabel * equityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, lawThirdLabel.bottom + 5, _scrollView.width - 20, 20)];
    equityLabel.text = @"二、知识产权声明:";
    [_scrollView addSubview:equityLabel];
    

    UILabel * equityFirstLabel = [[UILabel alloc] init];
    equityFirstLabel.text = @"(1)、能量库平台拥有网站上所有信息内容（除会员以个人身份发布的信息以外）的版权。未经许可不得转播使用。";
    equityFirstLabel.numberOfLines = 0;

    equityFirstLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:equityFirstLabel];
    CGRect equityFirstRect = [Utils getRectwithString:equityFirstLabel.text withFont:15 withWidth:kScreenWidth - 30];
    equityFirstLabel.frame = CGRectMake(15, equityLabel.bottom + 5, kScreenWidth - 30, equityFirstRect.size.height);

    
    UILabel * equitySecondLabel = [[UILabel alloc] init];
    equitySecondLabel.text = @"(2)、“能量库APP图标”以及“能量库”名称都为本公司版权所有。任何人不得擅自使用，否则将依法追究相关责任。";
    equitySecondLabel.numberOfLines = 0;

    equitySecondLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:equitySecondLabel];
    CGRect eequitySecondRect = [Utils getRectwithString:equitySecondLabel.text withFont:15 withWidth:kScreenWidth - 30];
    equitySecondLabel.frame = CGRectMake(15, equityFirstLabel.bottom + 5, kScreenWidth - 30, eequitySecondRect.size.height);
    
    
    /**
     三、隐私政策声明:
     */
    UILabel * privacyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, equitySecondLabel.bottom + 5, _scrollView.width - 20, 20)];
    privacyLabel.text = @"三、隐私政策声明:";
    [_scrollView addSubview:privacyLabel];

    
    UILabel * privacyFirstLabel = [[UILabel alloc] init];
    privacyFirstLabel.text = @"(1)、能量库尊重并保护所有使用本平台服务用户的个人隐私权。在未征得您事先许可的情况下，不会将这些信息对外披露或向第三方提供。您在同意电子协议之时，即视为您已经同意本隐私权政策全部内容。本隐私权政策属于能量库服务协议不可分割的一部分。";
    privacyFirstLabel.numberOfLines = 0;
    privacyFirstLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:privacyFirstLabel];
    CGRect privacyFirstRect = [Utils getRectwithString:privacyFirstLabel.text withFont:15 withWidth:kScreenWidth - 30];
    privacyFirstLabel.frame = CGRectMake(15, privacyLabel.bottom + 5, kScreenWidth - 30, privacyFirstRect.size.height);

    /**
     三、隐私政策声明:
     */
    UILabel * noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, privacyFirstLabel.bottom + 5, _scrollView.width - 20, 20)];
    noticeLabel.text = @"四、特别注意事项声明:";
    [_scrollView addSubview:noticeLabel];

    
    UILabel * noticeFirstLabel = [[UILabel alloc] init];
    noticeFirstLabel.text = @"(1)、您的账户均有安全保护功能，请妥善保管您的账户及密码信息。";
    noticeFirstLabel.numberOfLines = 0;

    noticeFirstLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:noticeFirstLabel];
    CGRect noticeFirstRect = [Utils getRectwithString:noticeFirstLabel.text withFont:15 withWidth:kScreenWidth - 30];
    noticeFirstLabel.frame = CGRectMake(15, noticeLabel.bottom + 5, kScreenWidth - 30, noticeFirstRect.size.height);


    UILabel * noticeSecondLabel = [[UILabel alloc] init];
    noticeSecondLabel.text = @"(2)、如果您不是具备完全民事权利能力和完全民事行为能力的自然人，您无权使用能量库平台服务，因此能量库希望您不要向我们提供任何个人信息。";
    noticeSecondLabel.numberOfLines = 0;

    noticeSecondLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:noticeSecondLabel];
    
    CGRect noticeSecondRect = [Utils getRectwithString:noticeSecondLabel.text withFont:15 withWidth:kScreenWidth - 30];
    noticeSecondLabel.frame = CGRectMake(15, noticeFirstLabel.bottom + 5, kScreenWidth - 30, noticeSecondRect.size.height);
    
    [_scrollView setContentSize:CGSizeMake(0, noticeSecondLabel.bottom + 5)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
