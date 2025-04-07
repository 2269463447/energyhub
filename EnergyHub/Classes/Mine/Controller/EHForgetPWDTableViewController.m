
//
//  EHForgetPWDTableViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/9/16.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHForgetPWDTableViewController.h"
#import "EHBusinessCell.h"
#import "EHEmailFindPWDViewController.h"
#import "EHPhoneFIndPWdViewController.h"

@interface EHForgetPWDTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation EHForgetPWDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = kBackgroundColor;
    self.tableView.rowHeight = 50;
    RegisterCellToTable(@"EHBusinessCell", self.tableView);
}

#pragma mark -- Getter

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"邮箱找回", @"手机号找回"];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHBusinessCell" forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 调整文字与图标的距离
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8.f)];
    header.backgroundColor = kBackgroundColor;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.row];
    
    if ([title isEqualToString:@"邮箱找回"]) {
        EHEmailFindPWDViewController *emailVC = [[EHEmailFindPWDViewController alloc] init];
        emailVC.title = title;
        [self.navigationController pushViewController:emailVC animated:YES];
    }else if ([title isEqualToString:@"手机号找回"]) {
        EHPhoneFIndPWdViewController *phoneVC = [[EHPhoneFIndPWdViewController alloc] init];
        phoneVC.title = title;
        [self.navigationController pushViewController:phoneVC animated:YES];
    }
}

@end
