//
//  JEShareManager.m
//  Energy
//
//  Created by sky on 07/15/19.
//  Copyright © 2019 sky. All rights reserved.
//

#import "EHShareManager.h"
#import "OpenShareHeader.h"
#import "AppDelegate.h"
#import "JESmartButton.h"

@interface EHShareActionViewController : UIViewController

@property (nonatomic,strong)NSDictionary *shareData;

- (void)showShareAction;

@end

@implementation EHShareActionViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0] ;
//    [self.view addSubview:self.collectionView];
    // 如果微信和微博都没有安装，则不能分享
    if (![OpenShare isWeixinInstalled] && ![OpenShare isWeiboInstalled]) {
//        [MBProgressHUD showMessage:l_loading toView:self.view] ;
    }
}

- (void)setupUI {
    DefineWeakSelf
    UIView *darkCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    darkCoverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
    [darkCoverView bk_whenTapped:^{
        [weakSelf cancelButtonClicked] ;
    }];
    
    [self.view addSubview:darkCoverView];
    
    NSArray *titles = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"新浪微博"] ;
    NSArray *images = @[[UIImage imageNamed:@"wx_session"],
                        [UIImage imageNamed:@"wx_moments"],
                        [UIImage imageNamed:@"qq_friend"],
                        [UIImage imageNamed:@"qq_zone"],
                        [UIImage imageNamed:@"weibo"]] ;
    CGFloat itemW = 70, itemH = 70;
    CGFloat margin = 0 ; //左右边距 32
    NSInteger rowCount = 4;
    CGFloat padding = 1;
    CGFloat iconW = (kScreenWidth - rowCount - 1) / rowCount;
    CGFloat iconH = iconW;
    CGFloat itemX = 0;
    CGFloat containerHeight = ceil(1.0f * titles.count / rowCount) * iconH;
    CGFloat itemY = (containerHeight - iconH) * .5 ;
    UIView *itemContainer = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, containerHeight)];
    itemContainer.tag = 300;
    itemContainer.backgroundColor = EHPopperColor;
    [self.view addSubview:itemContainer];
    
    for (int i = 0; i < titles.count; i++) {
        itemX = margin + i % rowCount * (iconW + padding) ;
        itemY = i / rowCount * (iconH + padding) ;
        UIView *plate = [[UIView alloc]initWithFrame:CGRectMake(itemX, itemY, iconW, iconH)];
        JESmartButton *itemButton =
        [[JESmartButton alloc] initWithStyle:JESmartButtonLayoutStyleV];
        // itemButton.layer.borderWidth = 1;
        // itemButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        itemButton.imageTitleMargin = 6;
        itemButton.frame = CGRectMake(0, 0, itemW, itemH);
        [itemButton setImage:images[i] forState:UIControlStateNormal] ;
        itemButton.imageView.size = CGSizeMake(30, 43);
        [itemButton setTitle:titles[i] forState:UIControlStateNormal] ;
        itemButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [itemButton setTitleColor:EHFontColor forState:UIControlStateNormal];
        itemButton.tag = i ;
        [itemButton addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside] ;
        itemButton.center = CGPointMake(iconW * .5, iconH * .5);
        [plate addSubview:itemButton];
        [itemContainer addSubview:plate] ;
    }
    
    // animation
    [UIView animateWithDuration:.25 animations:^{
        itemContainer.y = kScreenHeight - containerHeight;
    }];
}

- (void)shareStatus:(BOOL)success {
    if (success) {
        [MBProgressHUD showSuccess:@"分享成功" toView:nil];
    } else {
        [MBProgressHUD showError:@"分享失败" toView:nil];
    }
    [self remove]; // 分享完成后移除UI
}

- (void) itemButtonClicked:(UIButton *) sender {
    OSMessage *shareModel = [[OSMessage alloc]init];
    shareModel.title = @"能量库";
    shareModel.desc = self.shareData[@"content"];
    shareModel.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.sycy888.com/app/img/ic_energy.jpg"]];
    shareModel.link = self.shareData[@"shareUrl"];
    switch (sender.tag) {
        case 0:
        {
            if (![OpenShare isWeixinInstalled]) {
                [MBProgressHUD showError:@"微信APP未安装" toView:nil];
                return;
            }
            // 微信好友
            [OpenShare shareToWeixinSession:shareModel Success:^(OSMessage *message) {
                EHLog(@"微信分享到会话成功：\n%@", message);
                [self shareStatus:YES];
            } Fail:^(OSMessage *message, NSError *error) {
                EHLog(@"微信分享到会话失败：\n%@\n%@", error, message);
                [self shareStatus:NO];
            }];
            break;
        }
        case 1:
        {
            if (![OpenShare isWeixinInstalled]) {
                [MBProgressHUD showError:@"微信APP未安装" toView:nil];
                return;
            }
            // 微信朋友圈
            shareModel.title = self.shareData[@"content"];
            [OpenShare shareToWeixinTimeline:shareModel Success:^(OSMessage *message) {
                EHLog(@"微信分享到朋友圈成功：\n%@", message);
                [self shareStatus:YES];
            } Fail:^(OSMessage *message, NSError *error) {
                EHLog(@"微信分享到朋友圈失败：\n%@\n%@", error, message);
                [self shareStatus:NO];
            }];
            break;
        }
        case 2:
        {
            if (![OpenShare isQQInstalled]) {
                [MBProgressHUD showError:@"QQ未安装" toView:nil];
                return;
            }
            // QQ好友
            [OpenShare shareToQQFriends:shareModel Success:^(OSMessage *message) {
                EHLog(@"分享到QQ好友成功:%@", message);
                [self shareStatus:YES];
            } Fail:^(OSMessage *message, NSError *error) {
                EHLog(@"分享到QQ好友失败:%@\n%@", message, error);
                [self shareStatus:NO];
            }];
            break;
        }
        case 3:
        {
            if (![OpenShare isQQInstalled]) {
                [MBProgressHUD showError:@"QQ未安装" toView:nil];
                return;
            }
            // QQzone
            [OpenShare shareToQQZone:shareModel Success:^(OSMessage *message) {
                EHLog(@"分享到QQ空间成功:%@", message);
                [self shareStatus:YES];
            } Fail:^(OSMessage *message, NSError *error) {
                EHLog(@"分享到QQ空间失败:%@\n%@", message, error);
                [self shareStatus:NO];
            }];
            break;
        }
        case 4:
        {
            if (![OpenShare isWeiboInstalled]) {
                [MBProgressHUD showError:@"微博APP未安装" toView:nil];
                return;
            }
            // 微博
            shareModel.title = [NSString stringWithFormat:@"%@-%@ %@", shareModel.title, shareModel.desc, shareModel.link];
            shareModel.link = nil; // link 和 image 只能存在一种
            [OpenShare shareToWeibo:shareModel Success:^(OSMessage *message) {
                EHLog(@"分享到sina微博成功:\%@",message);
                [self shareStatus:YES];
            } Fail:^(OSMessage *message, NSError *error) {
                EHLog(@"分享到sina微博失败:\%@\n%@",message,error);
                [self shareStatus:NO];
            }];
            break;
        }
        default:
            break;
    }
}

- (void)showShareAction {
    [self setupUI];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
    [delegate.window addSubview:self.view] ;
    [delegate.window.rootViewController addChildViewController:self] ;
}

- (void) cancelButtonClicked {
    
    UIView *container = [self.view viewWithTag:300];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0.5 ;
        container.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self remove] ;
    }] ;
}

- (void) remove {
    [self.view removeFromSuperview] ;
    [self removeFromParentViewController] ;
}

@end

static EHShareManager *shareManager = nil ;

@interface EHShareManager ()

//@property (nonatomic, copy) JEWeixinShareCompletionBlock shareResult;

@end

@implementation EHShareManager

+ (instancetype) instance {
    static dispatch_once_t createQueue;
    dispatch_once(&createQueue, ^{
        shareManager = [[EHShareManager alloc] init];
    });
    return shareManager;
}

+ (void)configPlatforms {
    //第一步：注册key
    [OpenShare connectQQWithAppId:@"1106021414"];
    [OpenShare connectWeiboWithAppKey:@"2070304577"];
    [OpenShare connectWeixinWithAppId:@"wxd3ac44bd9e6ecb3b"];
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    return [OpenShare handleOpenURL:url];
}

+ (void)shareInfo:(NSDictionary *)info inView:(UIView *)view {
    
    EHShareActionViewController *shareController = [[EHShareActionViewController alloc]init];
    // 分享参数
    shareController.shareData = info;
    [shareController showShareAction];
}

+ (void)shareToView:(UIView *)view inviteCode:(NSString *)inviteCode {
    
    if (IsLogin) {
        inviteCode = [EHUserInfo sharedUserInfo].Id;
    }
    NSString *shareUrl = nil;
    if (inviteCode.length > 0) {
        shareUrl = [@"http://www.sycy888.com/app/s/yaoQingMa.app?id=" stringByAppendingString:inviteCode];
    }else{
        shareUrl = @"http://www.sycy888.com/app/s/yaoQingMa.app";
    }
    NSDictionary *info = @{@"content":@"每天学一点,得到大提升",@"shareUrl": shareUrl};
    [self shareInfo:info inView:view];
}

@end
