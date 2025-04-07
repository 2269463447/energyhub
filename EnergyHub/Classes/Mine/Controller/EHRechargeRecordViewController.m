//
//  EHRechargeRecordViewController.m
//  EnergyHub
//
//  Created by cpf on 2018/1/3.
//  Copyright © 2018年 EnergyHub. All rights reserved.
//

#import "EHRechargeRecordViewController.h"
#import "EHMineService.h"
#import "EHRechargeRecordModel.h"
#import "EHRechargeRecordCell.h"

@interface EHRechargeRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) EHMineService *service;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation EHRechargeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的充值记录";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHRechargeRecordCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self loadNewData];
}

#pragma mark -- Request

- (void)loadNewData {
    NSDictionary * dic = @{@"id": [[EHUserInfo sharedUserInfo] Id]};
    DefineWeakSelf
    [self.service rechargeRecordParam:dic successBlock:^(NSDictionary * result) {
        [weakSelf handleData:result];
    } errorBlock:^(EHError *error) {
        
    }];
}

- (void)handleData:(NSDictionary *)dic {
    
//    NSDictionary *response = dic[EHResponseKey];
    NSArray *courseArray = [EHRechargeRecordModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
    [self.dataArray addObjectsFromArray:courseArray];
    [self.tableView reloadData];
}


#pragma mark -- Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavigationBarH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (EHMineService *)service {
    if (!_service) {
        _service = [[EHMineService alloc] init];
    }
    return _service;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHRechargeRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
