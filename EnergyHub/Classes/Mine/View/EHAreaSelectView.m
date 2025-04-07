//
//  EHAreaSelectView.m
//  EnergyHub
//
//  Created by cpf on 2017/8/28.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHAreaSelectView.h"
#import "EHAreaSelectCell.h"

@interface EHAreaSelectView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation EHAreaSelectView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = 40;
        RegisterCellToTable(@"EHAreaSelectCell", self);
        self.showsVerticalScrollIndicator = FALSE;
    }
    return self;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHAreaSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHAreaSelectCell" forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.clickBlock) {
        self.clickBlock(self.dataArray[indexPath.row]);
    }
}

- (void)reloadDataByArray:(NSArray *)array {
    self.dataArray = [NSArray arrayWithArray:array];
    [self reloadData];
}

@end
