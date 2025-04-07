//
//  EHPayDownloadViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/3.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHPayDownloadViewController.h"
#import "EHHomeService.h"
#import "EHPayDownloadTipCell.h"
#import "EHPayDownloadUserInfoCell.h"
#import "EHPayDownloadCourseInfoCell.h"
#import "EHPayDownloadMethodCell.h"
#import "UIViewController+Share.h"
//#import "EHPayManagner.h"

@interface EHPayDownloadViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    EHPayDownloadMethodDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EHHomeService *homeService;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, assign) PayMethod payMethod;

@end

@implementation EHPayDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self startLoadData];
}

- (void)setupUI {
    self.title = @"购买离线视频";
    self.view.backgroundColor = kBackgroundColor;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    RegisterCellToTable([EHPayDownloadTipCell cellIdentifier], self.tableView)
    RegisterCellToTable([EHPayDownloadUserInfoCell cellIdentifier], self.tableView)
    RegisterCellToTable([EHPayDownloadCourseInfoCell cellIdentifier], self.tableView)
    RegisterCellToTable([EHPayDownloadMethodCell cellIdentifier], self.tableView)
    
    // buy button
    CGFloat buttonY = kScreenHeight - 90 - NavigationBarH;
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, buttonY, kScreenWidth, 90)];
    container.backgroundColor = kBackgroundColor;
    [self.view addSubview:container];
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.frame = CGRectMake(35, 5, kScreenWidth - 90, 44);
    //buyButton.enabled = NO;
    buyButton.backgroundColor = EHMainColor;//[UIColor grayColor];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton setTitle:@"购买离线服务" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(payForCourse) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:buyButton];
    self.buyButton = buyButton;
    // barItem
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"back"] target:self action:@selector(backAction)];
    [self facilitateShare];
}

- (void)startLoadData {
    // 提示信息
    [self.listData addObject:@[[EHPayDownloadTipCell cellIdentifier]]];
    // 会员信息
    NSMutableArray *rowArray = [NSMutableArray array];
    [rowArray addObject:[EHPayDownloadUserInfoCell cellIdentifier]];
    [rowArray addObject:[EHPayDownloadCourseInfoCell cellIdentifier]];
    //[rowArray addObject:[EHPayDownloadMethodCell cellIdentifier]];
    [self.listData addObject:rowArray];
    [self.tableView reloadData];
}

- (void)backAction {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Custom Events

- (void)payForCourse {
    
    NSInteger recharge = [self.dataInfo[@"cost"] floatValue] * 13;
    // 余额不足
    if (![[EHUserInfo sharedUserInfo] isAffordable:recharge]) {
        [MBProgressHUD showError:@"余额不足，请充值!" toView:self.view];
        return;
    }
    NSInteger courseId = [self.dataInfo[@"courseId"] integerValue];
    NSDictionary *param = @{@"id": @(courseId),
                            @"money": @(recharge),
                            @"uuid": [EHUserInfo sharedUserInfo].uuid
                            };
    DefineWeakSelf
    [self.homeService payForCourseWithParam:param successBlock:^(NSDictionary *code) {
        // 支付成功，开始下载
        [MBProgressHUD showSuccess:@"支付成功！" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 支付成功, 跳转到下载界面
            [weakSelf dismissViewControllerAnimated:NO completion:NULL];
            [[NSNotificationCenter defaultCenter] postNotificationName:DownloadCourseNotification object:nil userInfo:@{@"tid": weakSelf.dataInfo[@"courseId"]}];
        });
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:self.view];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArray = self.listData[section];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *rowArray = self.listData[indexPath.section];
    NSString *cellIdentifier = rowArray[indexPath.row];
    
    if ([cellIdentifier isEqualToString:[EHPayDownloadTipCell cellIdentifier]]) {
        EHPayDownloadTipCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        return cell;
    }else if ([cellIdentifier isEqualToString:[EHPayDownloadUserInfoCell cellIdentifier]]) {
        EHPayDownloadUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        return cell;
    }else if ([cellIdentifier isEqualToString:[EHPayDownloadCourseInfoCell cellIdentifier]]) {
        EHPayDownloadCourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.dataInfo = self.dataInfo;
        return cell;
    }else if ([cellIdentifier isEqualToString:[EHPayDownloadMethodCell cellIdentifier]]) {
        EHPayDownloadMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *rowArray = self.listData[indexPath.section];
    NSString *cellIdentifier = rowArray[indexPath.row];
    
    if ([cellIdentifier isEqualToString:[EHPayDownloadTipCell cellIdentifier]]) {
        
        return [EHPayDownloadTipCell cellHeight];
    }else if ([cellIdentifier isEqualToString:[EHPayDownloadUserInfoCell cellIdentifier]]) {
        
        return [EHPayDownloadUserInfoCell cellHeight];
    }else if ([cellIdentifier isEqualToString:[EHPayDownloadCourseInfoCell cellIdentifier]]) {
        
        return [EHPayDownloadCourseInfoCell cellHeight];
    }else if ([cellIdentifier isEqualToString:[EHPayDownloadMethodCell cellIdentifier]]) {
        
        return [EHPayDownloadMethodCell cellHeight];
    }

    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 8.f;
    }
    return 4.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 4.f)];
    header.backgroundColor = kBackgroundColor;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 4.f)];
    footer.backgroundColor = kBackgroundColor;
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - EHPayDownloadMethodDelegate

- (void)didSelectPayMethod:(PayMethod)method {
    
    if (self.payMethod == PayMethodNone) {
        self.buyButton.enabled = YES;
        self.buyButton.backgroundColor = EHMainColor;
    }
    self.payMethod = method;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kBackgroundColor;
        CGFloat offsetY = 95 + NavigationBarH;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, offsetY, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, offsetY, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (EHHomeService *)homeService {
    if (!_homeService) {
        _homeService = [[EHHomeService alloc]init];
    }
    return _homeService;
}

- (NSMutableArray *)listData {
    if (!_listData) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}

#pragma mark - Memory

- (void)dealloc {
    
    EHLog(@"%@ is dealloced.", [self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
