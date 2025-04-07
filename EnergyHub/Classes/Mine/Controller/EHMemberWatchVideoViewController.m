//
//  EHMemberWatchVideoViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHMemberWatchVideoViewController.h"
#import "UIViewController+Share.h"

@interface EHMemberWatchVideoViewController ()

@end

@implementation EHMemberWatchVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    [self facilitateShare];
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
