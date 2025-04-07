//
//  EHQRCodeViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/11.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHQRCodeViewController.h"
#import "EHMineService.h"
#import "UIImageView+LoadImage.h"

@interface EHQRCodeViewController ()

@property (nonatomic, strong) UIImageView *qrcodeImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) EHMineService *service;

@end

@implementation EHQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat qrcodeX = 40;
    CGFloat qrcodeW = kScreenWidth - qrcodeX * 2;
    _qrcodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(qrcodeX, 60, qrcodeW, qrcodeW)];
    _qrcodeImageView.backgroundColor = kBackgroundColor;
    [self.view addSubview:_qrcodeImageView];
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _qrcodeImageView.bottom, kScreenWidth, 40)];
    _contentLabel.numberOfLines = 2;
    _contentLabel.centerX = _qrcodeImageView.centerX;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_contentLabel];
    [self startLoadData];
}

- (void)startLoadData {
    
    _service = [[EHMineService alloc]init];
    
    DefineWeakSelf
    [_service appQRCodeWithParam:@{} successBlock:^(NSDictionary *qrcode) {
        if (qrcode) {
            [weakSelf.qrcodeImageView loadImageWithRelativeURL:qrcode[@"paths"]];
            weakSelf.contentLabel.text = qrcode[@"content"];
        }
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
