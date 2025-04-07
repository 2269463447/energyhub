//
//  EHRecordsOfConsumptionViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/9/4.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHRecordsOfConsumptionViewController.h"
#import "UIViewController+Share.h"
#import "EHRecordHeaderCell.h"
#import "EHRecordsConsumptionTableView.h"
#import "EHMineService.h"
#import "NSDictionary+Category.h"
#import "EHRecordModel.h"
#import "EHCashWithdrawalTableView.h"
#import "EHIncomeDetailsTableView.h"

@interface EHRecordsOfConsumptionViewController ()<EHRecordHeaderCellDelegate>

/**
 顶部试图
 */
@property (nonatomic, strong) EHRecordHeaderCell *headerView;

/**
 已消费列表
 */
@property (nonatomic, strong) EHRecordsConsumptionTableView *recodeTableView;

/**
 收入明细列表
 */
@property (nonatomic, strong) EHIncomeDetailsTableView *incomeDetailsTableView;

/**
 提现申请,提现记录
 */
@property (nonatomic, strong) EHCashWithdrawalTableView *cashWithdrawalTableView;

/**
 网络
 */
@property (nonatomic, strong) EHMineService *service;

/**
 花费 和 剩余金额
 */
//@property (nonatomic, strong) NSDictionary *surplusDic;

@property (nonatomic, strong) NSArray *costArray;

@end

@implementation EHRecordsOfConsumptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self requireRecordData];
}

- (void)setupView {
    self.view.backgroundColor = kBackgroundColor;
    [self facilitateShare];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.recodeTableView];
    [self.view addSubview:self.incomeDetailsTableView];
    [self.view addSubview:self.cashWithdrawalTableView];
}

#pragma mark -- Getter

- (EHRecordHeaderCell *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"EHRecordHeaderCell" owner:self options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 10, kScreenWidth, 100);
        _headerView.backgroundColor = kBackgroundColor;
        _headerView.delegate = self;
        _headerView.userInfo = [EHUserInfo sharedUserInfo];
    }
    return _headerView;
}

- (EHRecordsConsumptionTableView *)recodeTableView {
    if (!_recodeTableView) {
        _recodeTableView = [[EHRecordsConsumptionTableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom + 10, kScreenWidth, kScreenHeight - self.headerView.bottom - 10 - 64) style:UITableViewStyleGrouped];
        _recodeTableView.backgroundColor = kBackgroundColor;
        _recodeTableView.recoresStyle = EHRecoresStyleCost;
    }
    return _recodeTableView;
}

- (EHIncomeDetailsTableView *)incomeDetailsTableView {
    if (!_incomeDetailsTableView) {
        _incomeDetailsTableView = [[EHIncomeDetailsTableView alloc] initWithFrame:self.recodeTableView.frame style:UITableViewStyleGrouped];
        _incomeDetailsTableView.backgroundColor = kBackgroundColor;
        _incomeDetailsTableView.hidden = YES;
    }
    return _incomeDetailsTableView;
}

- (EHCashWithdrawalTableView *)cashWithdrawalTableView {
    if (!_cashWithdrawalTableView) {
        _cashWithdrawalTableView = [[EHCashWithdrawalTableView alloc] initWithFrame:self.recodeTableView.frame style:UITableViewStyleGrouped];
        _cashWithdrawalTableView.hidden = YES;
        _cashWithdrawalTableView.backgroundColor = kBackgroundColor;
        DefineWeakSelf
        _cashWithdrawalTableView.withdrawBlock = ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        };
    }
    return _cashWithdrawalTableView;
}

- (EHMineService *)service{
    if (!_service) {
        _service = [[EHMineService alloc] init];
    }
    return _service;
}

#pragma mark -- Request

/**
 消费数据请求
 */
- (void)requireRecordData {
    
    DefineWeakSelf
    [self.service recordsConsumptionDataWithParam:@{@"id":[EHUserInfo sharedUserInfo].Id, @"apple": @"1"} successBlock:^(id obj) {
        [weakSelf updateViewDataByDic:obj];
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

- (void)updateViewDataByDic:(NSDictionary *)dict {
    NSArray *tmpArray = (NSArray *)[dict EHObjectForKey:@"expense"];
    self.costArray = (NSArray *)[EHRecordModel mj_objectArrayWithKeyValuesArray:tmpArray];
    NSString *number = [dict EHObjectForKey:@"number"];
    NSString *xiaofei = [dict EHObjectForKey:@"xiaofei"];
    NSDictionary *moneyDict = [NSDictionary dictionaryWithObjectsAndKeys:number, @"number", xiaofei, @"xiaofei", nil];
    self.cashWithdrawalTableView.balance = number;
    [self.cashWithdrawalTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    self.headerView.data = moneyDict;
    [self.recodeTableView setupDataByArray:self.costArray];
}

#pragma mark -- EHRecordHeaderCellDelegate

- (void)didSelectView:(EHRecordHeaderCell *)view index:(NSInteger)index {
    
    if ((index == 1 || index == 2) && [[EHUserInfo sharedUserInfo].roleid isEqualToString:@"0"]) {
        [MBProgressHUD showError:@"您不是老师会员" toView:self.view];
        return;
    }
    
    switch (index) {
        case 0:
        {
            self.recodeTableView.hidden = NO;
            self.incomeDetailsTableView.hidden = YES;
            self.cashWithdrawalTableView.hidden = YES;
        }
            break;
            
        case 1:
        {
            self.recodeTableView.hidden = YES;
            self.incomeDetailsTableView.hidden = NO;
            self.cashWithdrawalTableView.hidden = YES;
        }
            break;

        case 2:
        {
            self.recodeTableView.hidden = YES;
            self.incomeDetailsTableView.hidden = YES;
            self.cashWithdrawalTableView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
