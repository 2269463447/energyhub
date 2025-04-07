//
//  EHBaseViewController.m
//  Energy
//
//  Created by gaojuyan on 16/4/6.
//  Copyright © 2017年 Energy. All rights reserved.
//

#import "EHBaseViewController.h"

@implementation UIViewController(EHBase)

+ (instancetype)instance {
    EHLog(@"====base instance = %@", NSStringFromClass(self));
    //NSAssert(NO, @"subclass must override this method!");
    return [[self alloc]init];
}

- (void)commonInit
{
    
}

- (void)doInViewDidLoad
{
    [self adaptiveNavigation];
}

- (void)adaptiveNavigation {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = kBackgroundColor;
        appearance.backgroundImage = [[UIImage alloc] init];
        appearance.shadowColor = nil;
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }
}

- (void)startLoadData
{
    
}

- (void)refreshData
{
    
}

- (void)loadDataModel
{
    
}

- (void)unloadDataModel
{
    
}

@end


@implementation EHBaseViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self _baseCommonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self _baseCommonInit];
    }
    return self;
}

- (void)_baseCommonInit
{
    [self commonInit];
    //self.title = l_baseTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self doInViewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_needNav) {
        [self setNavBar];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

#pragma mark - StatusBarStyle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Memory

- (void)dealloc
{
    if (self.isViewLoaded)
    {
        for (UIView *view in self.view.subviews)
        {
            if ([view isKindOfClass:[UIScrollView class]])
            {
                [(UIScrollView *)view setDelegate:nil];
                if ([view isKindOfClass:[UITableView class]])
                {
                    [(UITableView *)view setDataSource:nil];
                }
            }
        }
    }
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unloadDataModel];
}


- (void)setNavBar {
    if (!_navColor) {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        
        // 设置导航栏为透明
        navigationBar.translucent = YES;

        // 获取状态栏的高度
        CGFloat statusBarHeight;
        if (@available(iOS 13.0, *)) {
            NSSet *set = [UIApplication sharedApplication].connectedScenes;
            UIWindowScene *windowScene = [set anyObject];
            UIWindow *window = windowScene.windows.firstObject;
            statusBarHeight =  window.safeAreaInsets.top;
        } else {
            UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
            statusBarHeight = window.safeAreaInsets.top;
        }
        
        // 创建渐变层
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[
            (__bridge id)[UIColor colorWithHexString:@"#FEE5D3"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#FAFAF8"].CGColor
        ];
        
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        
        // 设置渐变层的 frame 为导航栏的 bounds
        gradientLayer.frame = CGRectMake(0, -statusBarHeight, navigationBar.bounds.size.width, navigationBar.bounds.size.height+statusBarHeight);
        
        // 渲染渐变层为 UIImage
        UIGraphicsBeginImageContext(gradientLayer.bounds.size);
        [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _navColor = [UIColor colorWithPatternImage:image];
    }

    
    // 创建一个新的 UINavigationBarAppearance 对象
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];

    // 使用渐变图片作为导航栏背景
    appearance.backgroundColor = _navColor;
    appearance.shadowImage = [UIImage new];  // 禁用底部阴影
    appearance.shadowColor = [UIColor clearColor];  // 也可以将阴影颜色设置为透明
    // 设置导航栏的标准外观
    self.navigationController.navigationBar.standardAppearance = appearance;

    // 设置导航栏的滚动边缘外观（针对滚动视图）
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    
}


@end
