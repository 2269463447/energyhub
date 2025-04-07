//
//  EHActivityDetailViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2024/6/15.
//  Copyright © 2024 EnergyHub. All rights reserved.
//

#import "EHActivityDetailViewController.h"

@interface EHActivityDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
//@property (nonatomic, strong) EHActivityService *activityService;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *sectionArray;

@end

@implementation EHActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.bottomView];
    [self.view bringSubviewToFront:self.bottomView];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"kkkk";
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


#pragma mark -Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 96)];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 96, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 96, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // _tableView.tableHeaderView = self.bannerView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 186, kScreenWidth, 90)];
        _bottomView.backgroundColor = kBackgroundColor;
        UIButton *queryButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 8, 120, 44)];
        [queryButton setTitle:@"在线咨询" forState:UIControlStateNormal];
        [queryButton setBackgroundColor:EHMainColor];
        UIButton *joinButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth  - 136, 8, 120, 44)];
        [joinButton setTitle:@"我要报名" forState:UIControlStateNormal];
        [joinButton setBackgroundColor:EHMainColor];
        [_bottomView addSubview:queryButton];
        [_bottomView addSubview:joinButton];
        EHLog(@"createAction bottom");
    }
    return _bottomView;
}



@end
