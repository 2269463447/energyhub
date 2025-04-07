//
//  EHMessageListViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHMessageListViewController.h"
#import "EHMessageService.h"
#import "EHMessageDetailViewController.h"

@interface EHMessageListViewController ()

@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) EHMessageService *service;

@end

@implementation EHMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self startLoadData];
}

- (void)setupUI {
    
    self.title = @"消息";
    self.view.backgroundColor = kBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)startLoadData {
    
    DefineWeakSelf
    
    [self.service messageListWithParam:@{} successBlock:^(NSArray *messageList) {
        [weakSelf loadMessageListFinished:messageList];
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

- (void)loadMessageListFinished:(NSArray *)messageList {
    
    self.listData = [NSMutableArray arrayWithArray:messageList];
    
    [self.tableView reloadData];
}


#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = kBackgroundColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    EHMessageData *message = self.listData[indexPath.row];
    cell.textLabel.text = message.title;
    cell.detailTextLabel.text = message.time;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EHMessageDetailViewController *detailController = [EHMessageDetailViewController instance];
    detailController.messageData = self.listData[indexPath.row];
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - Getter

- (NSMutableArray *)listData {
    if (!_listData) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}

- (EHMessageService *)service {
    
    if (!_service) {
        _service = [[EHMessageService alloc]init];
    }
    return _service;
}

#pragma mark - Memory

- (void)dealloc {
    
    EHLog(@"%@ dealloced", [self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
