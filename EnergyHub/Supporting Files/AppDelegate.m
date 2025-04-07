//
//  AppDelegate.m
//  LanguageStudy
//
//  Created by cpf on 2017/8/11.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "AppDelegate.h"
#import "EHTabbarController.h"
#import "IQKeyboardManager.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
//#import "WXApi.h"
//新浪微博SDK头文件
//#import "WeiboSDK.h"
//#import "EHPayManagner.h"
#import "EHShareManager.h"
#import "StoreObserver.h"
#import <AFNetworkReachabilityManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self monitorNetwork];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // tabBar controller
    EHTabbarController * tabVC = [[EHTabbarController alloc] init];
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];
    [self initIQKeyboardManager];
    [self initShareSDK];
    [self setupConfig];
    [EHShareManager configPlatforms];
    [self forceChangeStatusBarColor];
    // Attach an observer to the payment queue
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[StoreObserver sharedInstance]];
    return YES;
}

- (void)forceChangeStatusBarColor {
    
    if (@available(iOS 13.0, *)) {
        // default style
    } else {
        UIView *statusBar = [[[UIApplication sharedApplication]
                              valueForKey:@"statusBarWindow"]
                             valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor blackColor];
        }
    }
}

- (void)setupConfig {
    // wx appid
    // [WXApi registerApp:@"wxd3ac44bd9e6ecb3b"];
}

- (void)monitorNetwork {
    // monitor network
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                EHLog(@"===未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                EHLog(@"===网络不可用");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                EHLog(@"===WiFi网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                EHLog(@"===蜂窝流量");
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Remove the observer
    [[SKPaymentQueue defaultQueue] removeTransactionObserver: [StoreObserver sharedInstance]];
}

- (void)initShareSDK {
    /*
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeMail),
                                        @(SSDKPlatformTypeSMS),
                                        @(SSDKPlatformTypeCopy),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformTypeRenren),
                                        @(SSDKPlatformTypeFacebook),
                                        @(SSDKPlatformTypeTwitter),
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                 //             case SSDKPlatformTypeRenren:
                 //                 [ShareSDKConnector connectRenren:[RennClient class]];
                 //                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2070304577"
                                           appSecret:@"61608ec73659cf56a74fdcb44af11969"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxd3ac44bd9e6ecb3b"
                                       appSecret:@"4d13a9e85b82943aef6ff55b34d572ef"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106021414"
                                      appKey:@"E3aRrkCMKvEmpJJC"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
                 
             default:
                 break;
         }
     }];*/
}


- (void)initIQKeyboardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
}



#pragma mark - Open URL

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
 
    BOOL result = [EHShareManager handleOpenURL:url];
    if (result) {
        return result;
    }
    
    return YES;
}

#pragma mark -- iOS9.0 过时API

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL result = [EHShareManager handleOpenURL:url];
    if (result) {
        return result;
    }
    return YES;
}

@end
