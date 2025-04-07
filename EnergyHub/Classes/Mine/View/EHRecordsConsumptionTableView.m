//
//  EHRecordsConsumptionTableView.m
//  EnergyHub
//
//  Created by cpf on 2017/9/5.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHRecordsConsumptionTableView.h"
#import "EHRecordCell.h"
#import "EHRecordModel.h"

@interface EHRecordsConsumptionTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;


@end

@implementation EHRecordsConsumptionTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 55;
        RegisterCellToTable(@"EHRecordCell", self);
    }
    return self;
}

#pragma mark -- Request

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
    EHRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHRecordCell" forIndexPath:indexPath];
    cell.record = self.dataArray[indexPath.row];
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
    
    if (self.recoresStyle == EHRecoresStyleCost) {
        titleLabel.text = @"消费记录:";
    }else{
        titleLabel.text = @"收入明细:";
    }
    
    return headerView;
}

@end
