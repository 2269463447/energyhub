//
//  EHIncomeDetailsTableView.m
//  EnergyHub
//
//  Created by cpf on 2017/9/7.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHIncomeDetailsTableView.h"
#import "EHHowManyCashCell.h"
#import "EHMineService.h"
#import "EHIncomeDetailsModel.h"

@interface  EHIncomeDetailsTableView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) EHMineService *service;

@end

@implementation EHIncomeDetailsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 55;
        RegisterCellToTable(@"EHHowManyCashCell", self);
        [self requestIncomeDetailsData];
    }
    return self;
}

#pragma mark -- Getter

- (EHMineService *)service {
    if (!_service) {
        _service = [[EHMineService alloc] init];
    }
    return _service;
}

#pragma mark -- Request

- (void)requestIncomeDetailsData {
    
    DefineWeakSelf
    [self.service costListDataWithParam:@{@"id":[EHUserInfo sharedUserInfo].Id} successBlock:^(id obj) {
        
        NSArray *list = [obj objectForKey:@"list"];
        
        weakSelf.dataArray = [EHIncomeDetailsModel mj_objectArrayWithKeyValuesArray:list];
        [weakSelf reloadData];
        
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf];
    }];
}

- (void)setupDataByArray:(NSArray *)array {
    
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [self reloadData];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHHowManyCashCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHHowManyCashCell" forIndexPath:indexPath];
    cell.incomeDetail = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 40)];
    titleLabel.textColor = EHMainColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:titleLabel];
    titleLabel.text = @"收入明细:";
    
    return headerView;
}
@end
