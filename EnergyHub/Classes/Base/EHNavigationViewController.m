//
//  EHNavigationViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/12.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHNavigationViewController.h"
#import "UIImage+Extension.h"

@interface EHNavigationViewController ()

@end

@implementation EHNavigationViewController

//+ (void)load {
    // shadow color same to background color
//    [[UINavigationBar appearance] setShadowImage:[UIImage createImageWithColor:kBackgroundColor]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage createImageWithColor:kBackgroundColor] forBarMetrics:UIBarMetricsDefault];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
//    self.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        // 左上角
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 44, 44);
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        //[backButton sizeToFit];
        // 这句代码放在sizeToFit后面
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
