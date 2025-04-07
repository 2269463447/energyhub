//
//  EHVideoMenuView.m
//  EnergyHub
//
//  Created by cpf on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHVideoMenuView.h"
#import "EHVideoMenuModel.h"
#import "EHVidoMenuItem.h"
#import "EHVideoMenuHeaderCell.h"
#import "EHVideoMenuCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface EHVideoMenuView ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/**
 二级课程id
 */
@property (nonatomic, copy) NSString *cid;

@property (nonatomic, strong) UITableView * tableView;
/**
 目录数据
 */
@property (nonatomic, strong) NSMutableArray<EHVideoMenuModel*> * menuArray;

@end

@implementation EHVideoMenuView

- (instancetype)initWithFrame:(CGRect)frame
                      withCid:(NSString *)cid {
    self = [super initWithFrame:frame];
    if (self) {
        self.cid = cid;
        [self addSubview:self.tableView];
        self.tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    return self;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)loadMenuData:(NSArray *)dataArray {
    
    [self reloadMenuData:dataArray];
}

- (void)reloadMenuData:(NSArray *)data {
    self.menuArray = [NSMutableArray arrayWithArray:data];
    [self.tableView reloadData];
}

- (BOOL)hasCourse {
    
    return self.menuArray.count > 0;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.menuArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    EHVideoMenuModel *menuModel = self.menuArray[section];
    return menuModel.course.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHVideoMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    EHVideoMenuModel *menu = self.menuArray[indexPath.section];
    cell.menuItem = menu.course[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    EHVideoMenuHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    cell.menu = self.menuArray[section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EHVideoMenuModel *menu = self.menuArray[indexPath.section];
    EHVidoMenuItem *videoItem = menu.course[indexPath.row];
    videoItem.videoview++;
    EHVideoMenuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setMenuItem:videoItem];
    //[self requestVideoByCid:videoItem.ID];
    !_menuBlock ?: _menuBlock(videoItem, indexPath);
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无课程";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty"];
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"EHVideoMenuCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"EHVideoMenuHeaderCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
    }
    return _tableView;
}


@end
