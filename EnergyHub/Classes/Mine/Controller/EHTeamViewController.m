//
//  EHTeamViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2019/9/20.
//  Copyright © 2019 EnergyHub. All rights reserved.
//

#import "EHTeamViewController.h"
#import "EHTeamData.h"

@interface EHTeamViewController ()

@property (strong, nonatomic) NSMutableArray *listData ;

@end

@implementation EHTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self startLoadData];
}

#pragma mark - Private Methods

- (void)setupUI {
    
    self.title = @"团队详情";
//    self.tableView.backgroundColor = JEBackgroundColor;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
//    [self.tableView registerClass:[JEMemberHeaderView class] forHeaderFooterViewReuseIdentifier:JEMemberHeaderIdentifier];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)startLoadData {
    
//    [self.view showLoading];
    
//    DefineWeakSelf
    
//    [self.userInfoService memberCircleWithParam:@{} successBlock:^(EHTeamData *memberData) {
//        [weakSelf.view hiddenLoading];
//        [weakSelf loadDataFinished:memberData];
//    } errorBlock:^(JEError *error) {
//        [weakSelf.view hiddenLoading];
//        [MBProgressHUD showError:error.msg toView:weakSelf.view];
//    }];
    [self loadDataFinished:nil];
}

- (void)loadDataFinished:(EHTeamData *)memberData {
    
    NSMutableArray *listData = [NSMutableArray array];
    
    NSArray *names = @[@"一级成员",@"二级成员",@"三级成员"];
    NSArray *titles = @[@"我的团队成员",@"本月团队销售业绩",@"我的可提现业绩奖金额度"];
    NSMutableArray *teamStats = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        EHTeamData *stats = [[EHTeamData alloc]init];
        stats.levelName = names[i];
        stats.quantity = [NSString stringWithFormat:@"%d人", i + i * 100 / 50 + 899];
        stats.sectionTitle = titles[0];
        [teamStats addObject:stats];
    }
    NSMutableArray *saleStats = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        EHTeamData *stats = [[EHTeamData alloc]init];
        stats.levelName = names[i];
        stats.quantity = [NSString stringWithFormat:@"%d元", i + (i * 50 + 120) % 200 + 899];
        stats.sectionTitle = titles[1];
        [saleStats addObject:stats];
    }
    NSMutableArray *moneyStats = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        EHTeamData *stats = [[EHTeamData alloc]init];
        stats.levelName = names[i];
        stats.quantity = [NSString stringWithFormat:@"%d元", i + i * 100 + 899];
        stats.sectionTitle = titles[2];
        [moneyStats addObject:stats];
    }
    [listData addObject:teamStats];
    [listData addObject:saleStats];
    [listData addObject:moneyStats];
    
    self.listData = [NSMutableArray arrayWithArray:listData];
    
    [self.tableView reloadData];
}

# pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *data = self.listData[section];
    return data.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *items = self.listData[section];
    EHTeamData *teamData = items.firstObject;
    return teamData.sectionTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.textLabel.textColor = EHColor(100, 100, 100);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // 线下成员
    NSArray *items = self.listData[indexPath.section];
    EHTeamData *teamData = items[indexPath.row];
    cell.textLabel.text = teamData.levelName;
    cell.detailTextLabel.text = teamData.quantity;
    
    return cell;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    JEMemberHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:JEMemberHeaderIdentifier];
//    headerView.memberData = self.listData[section];
//    JEDefineWeakSelf
//    headerView.expandBlock = ^{
//        [weakSelf.tableView reloadData];
//    };
//    return headerView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Getter

- (NSMutableArray *) listData {
    if (!_listData) {
        _listData = [NSMutableArray array] ;
    }
    return _listData ;
}

//- (JEUserInfoService *) userInfoService {
//    if (!_userInfoService) {
//        _userInfoService = [[JEUserInfoService alloc] init] ;
//    }
//    return _userInfoService ;
//}

@end
