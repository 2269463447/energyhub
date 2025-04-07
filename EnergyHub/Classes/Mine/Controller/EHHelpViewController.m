//
//  EHHelpViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHHelpViewController.h"
#import "EHBusinessCell.h"
#import "EHWebViewController.h"
#import "UIViewController+Share.h"

static NSString * cellIdentifier = @"EHBusinessCell";

@interface EHHelpViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * dataSource;

@end

@implementation EHHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    [self facilitateShare];
}

#pragma mark -- getter

- (NSArray *)dataSource {
    if (!_dataSource) {
//        @"如何获取课程中的素材",
        _dataSource = @[
                        @"如何下载课程到移动设备",
                        @"如何更新到最新版本"];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 50;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"EHBusinessCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}

#pragma mark -- UITableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHBusinessCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.title = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushViewControllerByIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (void)pushViewControllerByIndex:(NSInteger)index {
    NSString * title = self.dataSource[index];
    
    if ([title containsString:@"如何获取课程中的素材"]) {
        
        EHWebViewController * webVC = [[EHWebViewController alloc] initWithSource:@"getClassMaterial" ofType:@"html"];
        webVC.title = title;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else if ([title containsString:@"如何下载课程到移动设备"]) {
        
        EHWebViewController * webVC = [[EHWebViewController alloc] initWithSource:@"getClassMaterialTOMobile" ofType:@"html"];
        webVC.title = title;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else if ([title containsString:@"如何更新到最新版本"]) {
        EHWebViewController * webVC = [[EHWebViewController alloc] initWithSource:@"updateVersion" ofType:@"html"];
        webVC.title = title;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
