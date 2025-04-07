//
//  EHCashWithdrawalTableView.m
//  EnergyHub
//
//  Created by cpf on 2017/9/6.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHCashWithdrawalTableView.h"
#import "EHHowManyCashCell.h"
#import "EHCashAccountCell.h"
#import "EHCashCountCell.h"
#import "EHMineService.h"
#import "EHCashWithdrawalModel.h"
#import "NSString+EHMoney.h"

@interface EHCashWithdrawalTableView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) EHMineService *service;
@end

@implementation EHCashWithdrawalTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        RegisterCellToTable(@"EHHowManyCashCell", self);
        RegisterCellToTable(@"EHCashAccountCell", self);
        RegisterCellToTable(@"EHCashCountCell", self);
        [self startLoadData];
    }
    return self;
}

#pragma mark -- Request

- (void)startLoadData {
    DefineWeakSelf
    [self.service cashWithdrawalListDataWithParam:@{} successBlock:^(id obj) {
        
        NSArray *list = [obj objectForKey:@"list"];
        
        weakSelf.dataArray = [EHCashWithdrawalModel mj_objectArrayWithKeyValuesArray:list];
        [weakSelf reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:self.superview];
    }];
}

- (void)setupDataByArray:(NSArray *)array {
    
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [self reloadData];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            EHHowManyCashCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHHowManyCashCell"];
            cell.cash = self.balance;
            return cell;
        }else if (indexPath.row == 1) {
            EHCashAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHCashAccountCell"];
            return cell;
        }else{
            EHCashCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHCashCountCell"];
            DefineWeakSelf
            cell.commitBtnClickBlock = ^{
                [weakSelf commitWithdrawalApplication];
            };
            return cell;
        }
    }
    EHHowManyCashCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EHHowManyCashCell"];
    cell.cashWithdrawal = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 30.f;
        }else if (indexPath.row == 1) {
            return 60.f;
        }else{
            return 100.f;
        }
    }else{
        return 40.f;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.f;
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
    
    if (section == 0) {
        titleLabel.text = @"提现申请";
    }else{
        titleLabel.text = @"提现记录";
    }
    return headerView;
}

#pragma mark -- Events 

- (void)commitWithdrawalApplication {
    NSIndexPath * alipayIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    EHCashAccountCell * accountCell = [self cellForRowAtIndexPath:alipayIndexPath];
    UITextField *alipayAccountTextFiled = accountCell.alipayAccountTextField;
    
    NSIndexPath * countIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    EHCashCountCell * countCell = [self cellForRowAtIndexPath:countIndexPath];
    UITextField *moneyTextFiled = countCell.countTextField;
    
    if (alipayAccountTextFiled.text.length == 0) {
        [MBProgressHUD showError:@"请输入账号" toView:self];
        return;
    }

    if (moneyTextFiled.text.length == 0) {
        [MBProgressHUD showError:@"请输入金额" toView:self];
        return;
    }
    CGFloat money = [self.balance floatValue] * 0.1f;
    if (money < 0.01f) {
        [MBProgressHUD showError:@"结余不足，不能提现" toView:self];
        return;
    }
    if (moneyTextFiled.text.floatValue > money) {
        [MBProgressHUD showError:@"金额不能大于拥有金额" toView:self];
        return;
    }

    if (moneyTextFiled.text.floatValue < 0.1f) {
        [MBProgressHUD showError:@"提现金额不能小于0.1" toView:self];
        return;
    }
    // 转成U币给后台，U币要求是整数
    NSString *number = [NSString stringWithFormat:@"%.f", moneyTextFiled.text.floatValue * 10];
    
    NSDictionary *parmas = @{@"account":accountCell.alipayAccountTextField.text,
                             @"number":number,
                             @"id":[EHUserInfo sharedUserInfo].Id};
    //DefineWeakSelf
    [self.service applyForCashWithdrawalsDataWithParam:parmas successBlock:^(id obj) {
        NSString *code = [obj objectForKey:@"code"];
        if ([code isEqualToString:@"000000"]) {
            [MBProgressHUD showSuccess:@"申请提交成功" toView:self];
            //[weakSelf startLoadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                !self.withdrawBlock ?: self.withdrawBlock();
            });
        }
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:self.superview];
    }];
}

#pragma mark - Getter

- (EHMineService *)service {
    if (!_service) {
        _service = [[EHMineService alloc] init];
    }
    return _service;
}

- (void)dealloc {
    
}

@end
