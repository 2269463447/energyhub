//
//  EHFriendlyLinkViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/12.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHFriendlyLinkViewController.h"
#import "EHFriendlyLinkDetailViewController.h"
#import "UIViewController+Share.h"

@interface EHFriendlyLinkViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation EHFriendlyLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self facilitateShare];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIButton *informationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    informationBtn.frame = CGRectMake(20, self.tableView.bottom - 56, kScreenWidth - 40, 35);
    informationBtn.backgroundColor = EHMainColor;
    [informationBtn setTitle:@"友情链接说明" forState:UIControlStateNormal];
    [informationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [informationBtn addTarget:self action:@selector(linkIntroduction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:informationBtn];
}
#pragma getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 60) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

#pragma mark -- button methods
- (void)linkIntroduction:(UIButton *)sender {
    EHFriendlyLinkDetailViewController * detailVC = [[EHFriendlyLinkDetailViewController alloc] init];
    detailVC.title = @"友情链接说明";
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
