//
//  EHMessageDetailViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHMessageDetailViewController.h"
#import "EHMessageData.h"
#import "EHMessageService.h"


@interface EHMessageDetailViewController ()

@property (nonatomic, strong) EHMessageService *service;

@end

@implementation EHMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    self.title = @"消息详情";
    self.view.backgroundColor = kBackgroundColor;
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, NavigationBarH + 10, kScreenWidth - 20, kScreenHeight - NavigationBarH - 20)];
    contentLabel.numberOfLines = 0;
    NSMutableString *content = [NSMutableString stringWithFormat:@"%@\n", _messageData.title];
    [content appendFormat:@"%@\n", _messageData.time];
    [content appendFormat:@"%@\n\n", _messageData.comment];
    contentLabel.text = content;
    [contentLabel sizeToFit];
    [self.view addSubview:contentLabel];
    
    [self.service updateMessageWithParam:@{} successBlock:^(NSDictionary *info) {
        
    } errorBlock:^(EHError *error) {
        
    }];
}

#pragma mark - Getter

- (EHMessageService *)service {
    if (!_service) {
        _service = [[EHMessageService alloc]init];
    }
    return _service;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
