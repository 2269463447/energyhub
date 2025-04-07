//
//  EHReleasedCourseViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/10.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHReleasedCourseViewController.h"
#import "EHMineService.h"
#import "EHReleasedCourseCell.h"

@interface EHReleasedCourseViewController ()

@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) EHMineService *service;

@end

@implementation EHReleasedCourseViewController

#pragma mark - Life Cycle Methods

- (void) viewDidLoad {
    [super viewDidLoad];
    // 加载UI
    [self setupUI];
    [self startLoadData];
}

#pragma mark - Private Methods

- (void) setupUI {
    //self.title = @"我的发布";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    RegisterCellToTable([EHReleasedCourseCell cellIdentifier], self.tableView)
    //self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)startLoadData {
    
    DefineWeakSelf
    [self.service releasedCourseWithParam:@{} successBlock:^(NSArray *courseList) {
        weakSelf.listData = [NSMutableArray arrayWithArray:courseList];
        [weakSelf.tableView reloadData];
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EHReleasedCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:[EHReleasedCourseCell cellIdentifier] forIndexPath:indexPath];
    cell.dataModel = self.listData[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 调整文字与图标的距离
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 8.f ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [EHReleasedCourseCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
}

#pragma mark - Getter

- (EHMineService *) service {
    if (!_service) {
        _service = [[EHMineService alloc] init] ;
    }
    return _service ;
}

- (NSMutableArray *)listData {
    if (!_listData) {
        _listData = [[NSMutableArray alloc]init];
    }
    return _listData;
}

#pragma mark - Memory Methods

- (void) dealloc {
    
}

@end
