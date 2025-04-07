//
//  Define.h
//  EnergyHub
//
//  Created by cpf on 2017/8/12.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//


// Logo打印
#ifdef DEBUG // 调试状态, 打开LOG功能
#define EHLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define EHLog(...)
#endif

// API available

#define iOS_After(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define iOS_Before(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

//---------------Frame-----------------

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//---------------Color-----------------

//#define kBackgroundColor [UIColor colorWithHexString:@"#F0EFF4"]
#define kBackgroundColor [UIColor colorNamed:@"BackgroundColor"]
#define HexColor(hex) [UIColor colorWithHexString:hex]
#define RGBColor(r, g, b) [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f]
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha: a * 1.0f]

#define EHMainColor RGBColor(250, 160, 59)
#define EHLineColor RGBColor(206, 206, 206)
#define EHCommitBtnUnableColor RGBColor(221, 221, 221)

// 文字颜色
#define EHTextBlackColor RGBColor(74, 74, 74)
#define EHTextGrayColor  RGBColor(160, 160, 160)
#define EHTextDarkColor  RGBColor(51, 51, 51)
#define EHSeparatorColor [UIColor colorNamed:@"SeparatorColor"]
#define EHFontColor      [UIColor colorNamed:@"FontColor"]
#define EHPopperColor      [UIColor colorNamed:@"PopperColor"]

#pragma mark - system metrics

// App 版本信息
#define AppVersion    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define AppBuild      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

// 也可以这样：
// [[UIApplication sharedApplication] statusBarFrame]
// 来计算状态栏的高度
#define StatusBarH 20

// tabbar的高度
#define TabBarH 50

// 导航栏的高度 (导航栏44 + 状态栏20）
#define NavigationBarH 64
#define NavigationHeight 44
#define IPHONEX (kScreenHeight >= 812.f)
#define StatusBarHeight ( IPHONEX ? 44.f : 20.f)

#pragma mark - custom metrics

// 内容距离屏幕边缘的间距
#define CommonMargin 15
// tableView section footer or header 的高度
#define SectionFooterH 8

// 分页
#define PageLimit 10

// 广告位的比例
#define HomeBannerScale 2.3

#pragma mark - Cell register xib

// 注册table
#define RegisterCellToTable(_cellIdentifier,_table) \
[(_table) registerNib:[UINib nibWithNibName:(_cellIdentifier) bundle:nil] \
forCellReuseIdentifier:(_cellIdentifier)] ;

// 注册collection
#define RegisterCellToCollection(_cellIdentifier,_collection) \
[(_collection) registerNib:[UINib nibWithNibName:(_cellIdentifier) bundle:nil] \
forCellWithReuseIdentifier:(_cellIdentifier)];

// 定义 weakSelf
#define DefineWeakSelf \
__weak typeof(self) weakSelf = self;

//---------------NotifiationName-------------

#define LoginSuccessNotification   @"LoginSuccessNotification"
#define LogoutSuccessNotification  @"LogoutSuccessNotification"
#define AvatarUpdatedNotification  @"AvatarUpdatedNotification"

#define DownloadCourseNotification   @"DownloadCourseNotification"
#define BuyCourseSuccessNotification @"BuyCourseSuccessNotification"
#define DownloadItemSuccessNotification   @"DownloadItemSuccessNotification"

#define ModifyPasswordSuccessNotification @"ModifyPasswordSuccessNotification"


//---------------CacheKeyName-----------------

#define UserInfoKey @"UserInfoKey"


//---------------NET KEY-----------------
#define kRightCode @"000000"
#define kWrongCode @"999999"


/////////// schema ///////////

#define kAlipaySchema @"com.siyu.energyhub"

/////////// enum /////////////

typedef NS_ENUM(NSInteger, PayMethod) {
    PayMethodNone,
    PayMethodAlipay,
    PayMethodWeixin
};


