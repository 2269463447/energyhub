//
//  EHPlayVideoViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/13.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHPlayVideoViewController.h"
#import "EHPlayToolsView.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "UIImageView+LoadImage.h"
#import "ZFPlayerControlView.h"
#import "EHHomeService.h"
#import "EHVideoMenuView.h"
#import "EHCourseDetailView.h"
#import "EHShareManager.h"
#import "EHOfflineData.h"
#import "EHCourseDownloadView.h"
#import "EHPayDownloadViewController.h"
#import "EHNavigationViewController.h"
#import "EHDownloadManager.h"
#import <FCFileManager.h>
#import "EHVidoMenuItem.h"
#import "EHGiftView.h"
#import "EHPayGiftViewController.h"
#import "EHBuySingleClassViewController.h"
#import "EHLoginViewController.h"
#import "EHVideoMenuModel.h"
#import "EHVidoMenuItem.h"

const NSInteger kToolsViewTag = 1000;

@interface EHPlayVideoViewController ()
<
    EHPlayToolsViewDelegate,
    EHCourseDownloadDelegate
>

/** service **/
@property (nonatomic, strong) EHHomeService *homeService;
/** 当前选择的功能index **/
@property (nonatomic, assign) CGFloat currentIndex;
/** 当前播放的单节课程 **/
@property (nonatomic, copy) NSString *currentMenuId;
/** 视频播放 **/
//@property (nonatomic, strong) ZFPlayerView * playerView;
/** 播放器父视图 **/
//@property (nonatomic, strong) UIImageView * playFatherView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
/** advertisement **/
@property (nonatomic, strong) UIImageView *adImageview;
/** ad close button **/
@property (nonatomic, strong) UIButton *closeAdButton;
/** 工具栏 **/
@property (nonatomic, strong) EHPlayToolsView * toolsView;
/** 目录 **/
@property (nonatomic, strong) EHVideoMenuView *menuView;
/** 详情 **/
@property (nonatomic, strong) EHCourseDetailView *detailView;
/** 下载 **/
@property (nonatomic, strong) EHCourseDownloadView *downloadView;
/** 打赏 **/
@property (nonatomic, strong) EHGiftView *giftView;
/** 返回 */
@property (nonatomic, strong) UIButton *backBtn;

/** 菜单model **/
@property (nonatomic, strong) EHVideoMenuModel *currentMenuModel;
/** 当前播放的item **/
@property (nonatomic, strong) EHVidoMenuItem *currentItem;

@end

@implementation EHPlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupPlayer];
    //[self startLoadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startLoadData];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (void)setupUI {
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.toolsView];
    // component subviews
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.detailView];
    [self.view addSubview:self.downloadView];
    // 下载的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissCurrentController)
                                                 name:DownloadCourseNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(buyOnlineVideoSuccess:)
                                                 name:BuyCourseSuccessNotification
                                               object:nil];
}

- (void)setupPlayer {
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    playerManager.scalingMode = ZFPlayerScalingModeFill;
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    @weakify(self)
    self.controlView.portraitControlView.backBtnClickCallback = ^{
        @strongify(self)
        [self dismissCurrentController];
    };
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
//    self.player.pauseWhenAppResignActive = NO;
    
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
}

- (void)startLoadData {
    
    [self loadMenuData];
}

- (void)dismissCurrentController {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    CGFloat x = 0;
//    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
//    CGFloat w = CGRectGetWidth(self.view.frame);
//    CGFloat h = w*9/16;
//    self.containerView.frame = CGRectMake(x, y, w, h);
//}

- (void)loadMenuData {
    
    if (self.playType == EHPlayTypeOffline && _offlineData) {
        [self.menuView loadMenuData:_offlineData.data];
        return;
    }
    
    NSDictionary *param = @{@"cid": self.cid};
    if (IsLogin) {
        param = @{@"cid": self.cid, @"uid": [EHUserInfo sharedUserInfo].Id};
    }
    
    DefineWeakSelf
    
    [self.homeService menuListWithParam:param successBlock:^(NSArray *data) {
        [weakSelf loadCourseMenuFinished:data];
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

- (void)loadCourseMenuFinished:(NSArray *)menuList {
    // 第一次进入界面时默认第一课，如果从其他界面返回到此界面，则要记住之前选择的课程
    if (self.currentItem) {
        return;
    }
    if (menuList.count > 0) {
        [self loadCourseCost];
        [self loadCourseDetail];
        EHVideoMenuModel *menuData = menuList[0];
        self.currentMenuModel = menuData;
        NSArray *items = menuData.course;
        if (items.count > 0) {
            EHVidoMenuItem *item = items[0];
            self.currentMenuId = item.ID;
            self.currentItem = item;
        }
    }else {
//        [MBProgressHUD showError:@"暂无课程" toView:self.view];
    }
    [self.menuView loadMenuData:menuList];
}

- (void)playOfflineCourseWithItem:(EHVidoMenuItem *)menuItem atIndexPath:(NSIndexPath *)indexPath  {
    NSString *dirPath = [[EHDownloadManager sharedManager] unzipPathOfProduct:_cid.intValue];
    //NSArray *files = [FCFileManager listFilesInDirectoryAtPath:dirPath];
    NSString *videoPath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", menuItem.ID]] ;
    if ([FCFileManager existsItemAtPath:videoPath]) {
//        self.player.assetURL = [NSURL fileURLWithPath:videoPath isDirectory:NO];
        EHVideoMenuModel *menuModel = _offlineData.data[indexPath.section];
        EHVidoMenuItem *menuItem = menuModel.course[indexPath.row];
        [self.controlView showTitle:menuItem.name coverImage:[UIImage imageNamed:@"img_default"] fullScreenMode:ZFFullScreenModePortrait];
//        [self.player resetToPlayNewVideo:self.playerModel];
        [self.player.currentPlayerManager setAssetURL:[NSURL fileURLWithPath:videoPath isDirectory:NO]];
        [self.player.currentPlayerManager play];
    }
}

- (void)buyOnlineVideoSuccess:(NSNotification* )notification {
    // 购买成功后，直接播放
    EHVidoMenuItem *item = (EHVidoMenuItem *)notification.userInfo[@"data"];
    item.inLine = 1;//更新权限
    [self.menuView reloadData];
    [self playOnlineVideoWithItem:item];
}

- (void)playOnlineVideoWithItem:(EHVidoMenuItem *)menuItem {
    
    if (![Utils isReachable]) {
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
        return;
    }
    
    NSMutableDictionary *param = [@{@"cid": menuItem.ID} mutableCopy];
    if (IsLogin) {
        [param setObject:[EHUserInfo sharedUserInfo].Id forKey:@"uid"];
    }
    // 权限不足，需要购买
    if (menuItem.inLine == 0 && ![[EHUserInfo sharedUserInfo] isTeacher]) {
        [self gotoBuySingleClass:menuItem];
        return;
    }
    // 获取播放地址
    DefineWeakSelf
    [self.homeService videoDetailWithParam:param successBlock:^(NSDictionary * result) {
        
        NSString *videoURL = [result objectForKey:EHResponseKey];
        NSString *code = result[EHResponseCode];
        if ([code isEqualToString:EHSuccessCode]) {
            if (![videoURL hasPrefix:@"http"]) {
                videoURL = [NSString stringWithFormat:@"http://%@", videoURL];
            }
            [weakSelf.controlView showTitle:result[@"name"] coverImage:[UIImage imageNamed:@"img_default"] fullScreenMode:ZFFullScreenModeAutomatic];
            [weakSelf.player.currentPlayerManager setAssetURL:[NSURL URLWithString:videoURL]];
            [weakSelf.player.currentPlayerManager play];
            // 广告数据
            NSString *adLinkURL = result[@"advertising"];
            if ([adLinkURL isKindOfClass:[NSString class]]) {
                if (![adLinkURL hasPrefix:@"http"]) {
                    adLinkURL = [NSString stringWithFormat:@"http://%@", adLinkURL];
                }
                weakSelf.controlView.portraitControlView.adLinkURL = adLinkURL;
            }else {
                // 因为用的是同一个model，每次都要更新
                weakSelf.controlView.portraitControlView.adLinkURL = nil;
            }
            if ([result[@"advertisingURL"] isKindOfClass:[NSString class]]) {
                [weakSelf.controlView.portraitControlView updateAdvertisementImageURL:[NSString stringWithFormat:@"%@/%@", [[EHGlobal sharedGlobal] httpRestServer], result[@"advertisingURL"]]];
            }else {
                [weakSelf.controlView.portraitControlView updateAdvertisementImageURL:nil];
            }
        }else if ([code isEqualToString:EHNOPowerKey]) {
            [weakSelf gotoBuySingleClass:menuItem];
        }

    } errorBlock:^(EHError *error) {
        // @"请先登录购买观看权限
        if ([error.msg containsString:@"权限"]) {
            [weakSelf gotoBuySingleClass:menuItem];
        }else {
            [MBProgressHUD showError:error.msg toView:weakSelf.view];
        }
    }];
}

- (void)requestVideoURLWithItem:(EHVidoMenuItem *)menuItem atIndexPath:(NSIndexPath *)indexPath {
    
    if (!menuItem.ID) {
        [MBProgressHUD showError:@"缺少课程id" toView:self.view];
        return;
    }
    self.currentMenuId = menuItem.ID;
    self.currentItem = menuItem;
    // 缓存播放
    if (self.playType == EHPlayTypeOffline) {
        [self playOfflineCourseWithItem:menuItem atIndexPath:indexPath];
    }else {
        [self playOnlineVideoWithItem:menuItem];
    }
}

/**
 跳转单节课购买
 */
- (void)gotoBuySingleClass:(EHVidoMenuItem *)menuItem {
    //需要购买
    EHBuySingleClassViewController *singleVC = [[EHBuySingleClassViewController alloc] init];
    singleVC.menuItem = menuItem;
    EHNavigationViewController * nav = [[EHNavigationViewController alloc] initWithRootViewController:singleVC];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)loadCourseDetail {
    
    if (!self.cid) {
        [MBProgressHUD showError:@"课程不存在" toView:self.view];
    }
    
    // 加载缓存
    if (self.playType == EHPlayTypeOffline && _offlineData) {
        
        self.detailView.dataModel = _offlineData.data1;
        return;
    }
    
    DefineWeakSelf
    
    [self.homeService courseDetailWithParam:@{@"id": self.cid} successBlock:^(EHCourseDetail *detailData) {
        weakSelf.detailView.dataModel = detailData;
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

- (void)loadCourseCost {
    
    if (!self.cid) {
        [MBProgressHUD showError:@"课程不存在" toView:self.view];
    }
    
    // 已缓存
    if (self.playType == EHPlayTypeOffline && _offlineData) {
        self.downloadView.cost = nil;
        return;
    }
    
    DefineWeakSelf
    [self.homeService courseCostWithParam:@{@"id": self.cid} successBlock:^(NSString *cost) {
        weakSelf.downloadView.cost = cost;
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

#pragma mark - EHPlayToolsViewDelegate

- (void)didSelectView:(EHPlayToolsView *)view index:(NSInteger)index {
    
    if (_currentIndex == index) {
        return;
    }
    if (![self.menuView hasCourse]) {
//        [MBProgressHUD showError:@"暂无课程" toView:self.view];
        return;
    }
    
    switch (index) {
        case 0: // 目录
        case 1: // 详情
        case 3: // 缓存
        {
            UIView *targetView = [self.view viewWithTag:kToolsViewTag + index];
            UIView *currentView = [self.view viewWithTag:kToolsViewTag + _currentIndex];
            _currentIndex = index;
            
            targetView.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                targetView.x = 0;
                currentView.x = -kScreenWidth;
            } completion:^(BOOL finished) {
                currentView.hidden = YES;
            }];
        }
            break;
        
        case 2:
            // 打赏
            [self showGiftView];
            break;
    
        case 4:
        {
            // 分享H5播放页
            NSString *shareUrl = [NSString stringWithFormat:@"http://sycy888.com/share/#/?id=%@&vid=%@", self.cid, self.currentMenuId];
            NSString *pre = [[NSUserDefaults standardUserDefaults] stringForKey:@"courseAll"];
            NSString *content = [NSString stringWithFormat:@"能量库|%@|%@|今天我学完了 欧耶！", pre, self.currentItem.name];
            NSDictionary *info = @{@"content":content,@"shareUrl":shareUrl};
            [EHShareManager shareInfo:info inView:self.view];
        }
            break;
            
        default:
            break;
    }
}

- (void)showGiftView {
    // 登录后才能打赏
    /*
    if (![EHUserInfo sharedUserInfo].isLogin) {
        [MBProgressHUD showError:@"请先登录" toView:self.view];
        EHLoginViewController *login = [EHLoginViewController instance];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }*/
    [self.view addSubview:self.giftView];
    [self.giftView show];
}

#pragma mark - EHCourseDownloadDelegate

- (void)didClickedDownloadButton {
    
    // 缓存之后不能购买
    if (self.playType == EHPlayTypeOffline) {
        [MBProgressHUD showError:@"本课程已缓存" toView:self.view];
        return;
    }
    // 弹出购买界面
    if ([EHUserInfo sharedUserInfo].isLogin) {
        if (!self.detailView.dataModel || !self.downloadView.cost) {
            [MBProgressHUD showError:@"请检查网络" toView:self.view];
            return;
        }
        EHPayDownloadViewController *downloadVC = [EHPayDownloadViewController instance];
        downloadVC.dataInfo = @{@"courseName": self.detailView.dataModel.NAME,
                                   @"quantity": self.detailView.dataModel.chap,
                                   @"cost": self.downloadView.cost,
                                   @"courseId": self.cid};
        EHNavigationViewController *navi = [[EHNavigationViewController alloc]initWithRootViewController:downloadVC];
        [self presentViewController:navi animated:YES completion:NULL];
    }else {
//        [MBProgressHUD showError:@"请先登录" toView:self.view];
        EHLoginViewController *login = [EHLoginViewController instance];
        EHNavigationViewController *navi = [[EHNavigationViewController alloc]initWithRootViewController:login];
        [self presentViewController:navi animated:YES completion:NULL];
    }
}

#pragma mark - rotate

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Getter

- (EHHomeService *)homeService {
    if (!_homeService) {
        _homeService = [[EHHomeService alloc]init];
    }
    return _homeService;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(5, 0, 44, 44);
//        _backBtn.backgroundColor = [UIColor redColor];
        [_backBtn setImage:[UIImage imageNamed:@"back_play"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(dismissCurrentController) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 10, 5);
        _backBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI/2), 0.6, 0.6);
    }
    return _backBtn;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = YES;
    }
    return _controlView;
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, kScreenWidth, 240)];
        [_containerView setImage:[UIImage imageNamed:@"img_default"]];
        [_containerView addSubview:self.backBtn];
    }
    return _containerView;
}

//- (UIImageView *)playFatherView {
//    if (!_playFatherView) {
//        _playFatherView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 220)];
//        _playFatherView.image = [UIImage imageNamed:@"img_default"];
//        _playFatherView.userInteractionEnabled = YES;
//        [_playFatherView addSubview:self.backBtn];
//    }
//    return _playFatherView;
//}
//
//- (ZFPlayerView *)playerView {
//    if (!_playerView) {
//        _playerView = [[ZFPlayerView alloc] init];
//        [_playerView playerControlView:nil playerModel:self.playerModel];
//        _playerView.delegate = self;
//        _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
//        // 打开预览图
//        _playerView.hasPreviewView = NO;
//    }
//    return _playerView;
//}
//
//- (ZFPlayerModel *)playerModel {
//    if (!_playerModel) {
//        _playerModel = [[ZFPlayerModel alloc] init];
//        _playerModel.title = @"能量库";
////        _playerModel.placeholderImage = [UIImage imageNamed:@"img_default"];
//        _playerModel.fatherView = self.playFatherView;
//    }
//    return _playerModel;
//}

- (EHPlayToolsView *)toolsView {
    if (!_toolsView) {
        _toolsView = [[EHPlayToolsView alloc] initWithFrame:CGRectMake(0, self.containerView.bottom, kScreenWidth, 80)];
        _toolsView.delegate = self;
    }
    return _toolsView;
}

- (EHVideoMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[EHVideoMenuView alloc] initWithFrame:CGRectMake(0, self.toolsView.bottom, kScreenWidth, kScreenHeight - self.toolsView.bottom) withCid:self.cid];
        _menuView.tag = kToolsViewTag + 0;
        DefineWeakSelf
        _menuView.menuBlock = ^(EHVidoMenuItem *menuItem, NSIndexPath *indexPath) {
            [weakSelf requestVideoURLWithItem:menuItem atIndexPath:indexPath];
        };
        //[self loadMenuData];
    }
    return _menuView;
}

- (EHCourseDetailView *)detailView {
    
    if (!_detailView) {
        _detailView = [[EHCourseDetailView alloc]initWithFrame:CGRectMake(0, self.toolsView.bottom, kScreenWidth, kScreenHeight - self.toolsView.bottom)];
        _detailView.tag = kToolsViewTag + 1;
        _detailView.hidden = YES;
        //[self loadCourseDetail];
    }
    return _detailView;
}

- (EHCourseDownloadView *)downloadView {
    if (!_downloadView) {
        _downloadView = [[EHCourseDownloadView alloc]initWithFrame:CGRectMake(0, self.toolsView.bottom, kScreenWidth, kScreenHeight - self.toolsView.bottom)];
        _downloadView.tag = kToolsViewTag + 3;
        _downloadView.hidden = YES;
        _downloadView.delegate = self;
        //[self loadCourseCost];
    }
    return _downloadView;
}

- (EHGiftView *)giftView {
    
    if (!_giftView) {
        DefineWeakSelf
        _giftView = [EHGiftView giftViewWithBlock:^(NSInteger giftValue) {
            // 打赏
            EHPayGiftViewController *payGiftVC = [EHPayGiftViewController instance];
            payGiftVC.courseId = weakSelf.currentMenuId;
            payGiftVC.giftValue = giftValue;
            EHNavigationViewController *navi = [[EHNavigationViewController alloc]initWithRootViewController:payGiftVC];
            [weakSelf presentViewController:navi animated:YES completion:NULL];
        }];
    }
    return _giftView;
}

#pragma mark - Memory

- (void)dealloc {
    EHLog(@"%@ is dealloced", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
