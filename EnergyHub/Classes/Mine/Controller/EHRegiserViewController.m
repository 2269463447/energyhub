//
//  EHRegiserViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/28.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHRegiserViewController.h"
#import "EHRegisterCell.h"
#import "EHAreaSelectView.h"
#import "EHProvinceModel.h"
#import "EHCityModel.h"
#import "EHAreaModel.h"
#import "MJExtension.h"
#import "EHRegisterProtocolView.h"
#import "EHMineService.h"

@interface EHRegiserViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * dataSource;

/**
 地区负试图
 */
@property (nonatomic, strong) UIView *areaView;

/**
 注册按钮
 */
@property (nonatomic, strong) UIButton *registerBtn;

/**
 地区选择弹出试图
 */
@property (nonatomic, strong) EHAreaSelectView * areaSelectView;

/**
 弹出蒙层
 */
@property (nonatomic, strong) UIView *alphaView;

/**
 地区数组
 */
@property (nonatomic, strong) NSArray *areaArray;

/**
 省份数组 城市需要根据省份计算
 */
@property (nonatomic, strong) NSArray <NSString *>*provinceArray;

/**
 地区数组
 */
@property (nonatomic, strong) NSArray <NSString *>*districtArray;

/**
 当前地区数据
 */
@property (nonatomic, strong) EHProvinceModel * currentProvince;

/**
 网络
 */
@property (nonatomic, strong) EHMineService *netService;

/**
 注册协议
 */
@property (nonatomic, strong) EHRegisterProtocolView *protocolView;

@end

@implementation EHRegiserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setAreaData];
}

- (void)setupView {
    self.view.backgroundColor = kBackgroundColor;
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.areaView];
    [self.scrollView addSubview:self.alphaView];
    [self.scrollView addSubview:self.areaSelectView];
    [self.scrollView addSubview:self.registerBtn];
    [self.scrollView addSubview:self.protocolView];
    [self.view addSubview:self.scrollView];
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, self.registerBtn.bottom + 20)];
}

#pragma mark -- Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height)];
    }
    return _scrollView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.dataSource.count * 50) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.scrollEnabled = NO;
        RegisterCellToTable(@"EHRegisterCell", _tableView);
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@{@"imgName":@"icon_my",
                          @"placeholder":@"昵称:字数不能超20位(必填)"},
                        @{@"imgName":@"icon_my",
                          @"placeholder":@"会员账号:6-11位字母或数字(必填)"},
                        @{@"imgName":@"message",
                          @"placeholder":@"输入邮箱:字符不能超过20位(必填)"},
                        @{@"imgName":@"icon_psd",
                          @"placeholder":@"设置密码:6-9位字母、数字(必填)"},
                        @{@"imgName":@"icon_psd",
                          @"placeholder":@"确认密码(必填)"},
                        @{@"imgName":@"inviteCode",
                          @"placeholder":@"输入邀请码"}];
    }
    return _dataSource;
}

- (EHMineService *)netService {
    if (!_netService) {
        _netService = [[EHMineService alloc] init];
    }
    return _netService;
}

- (UIView *)areaView {
    if (!_areaView) {
        _areaView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom + 10, kScreenWidth, 90)];
        _areaView.backgroundColor = kBackgroundColor;
        [self setupAreaViewSubviews];
    }
    return _areaView;
}

- (void)setupAreaViewSubviews {
    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 20)];
    introduceLabel.text = @"请选择省市区:";
    introduceLabel.font = [UIFont systemFontOfSize:14];
    [_areaView addSubview:introduceLabel];
    
    CGFloat space = 30.f;
    CGFloat buttonWidth = (kScreenWidth - 20 - 2*space)/3;
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+buttonWidth*i + space*i, introduceLabel.bottom + 5.f, buttonWidth, 35.f);
        button.layer.borderWidth = 0.5;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.borderColor = EHLineColor.CGColor;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectArea:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 100;
        [_areaView addSubview:button];
    }
    
    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementBtn.frame = CGRectMake(10, introduceLabel.bottom + 5.f+40.f, 180, 25);
    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [agreementBtn setTitle:@"同意能量库教育网注册协议" forState:UIControlStateNormal];
    [agreementBtn setTitleColor:EHMainColor forState:UIControlStateNormal];
    [agreementBtn addTarget:self action:@selector(agreementBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_areaView addSubview:agreementBtn];
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.frame = CGRectMake(10, self.areaView.bottom + 30, kScreenWidth - 20, 40);
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn setBackgroundColor:EHMainColor];
        [_registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (EHAreaSelectView *)areaSelectView {
    if (!_areaSelectView) {
        _areaSelectView = [[EHAreaSelectView alloc] initWithFrame:CGRectMake((kScreenWidth - 250)/2, 0, 250, 100) style:UITableViewStyleGrouped];
        _areaView.backgroundColor = kBackgroundColor;
        _areaSelectView.hidden = YES;
    }
    return _areaSelectView;
}

- (UIView *)alphaView {
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = 0.4;
        _alphaView.hidden = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alphaViewClick)];
        [_alphaView addGestureRecognizer:tap];
    }
    return _alphaView;
}


- (EHRegisterProtocolView *)protocolView {
    if (!_protocolView) {
        _protocolView = [[[NSBundle mainBundle] loadNibNamed:@"EHRegisterProtocolView" owner:self options:nil] lastObject];
        _protocolView.hidden = YES;
        DefineWeakSelf
        _protocolView.agreeBlock = ^{
            weakSelf.protocolView.hidden = YES;
        };
    }
    return _protocolView;
}

#pragma mark -- Data

- (void)setAreaData {
    
    DefineWeakSelf
    NSBlockOperation *handleDataOperation = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf handleAreaData];
    }];
    
    [handleDataOperation start];
}

/**
 处理省份地区数据
 */
- (void)handleAreaData {
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"]];
    
    NSDictionary * data = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    NSArray * provinceArray = [data objectForKey:@"citylist"];
    NSArray * array = [EHProvinceModel mj_objectArrayWithKeyValuesArray:provinceArray];
    self.areaArray = [array mutableCopy];
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (EHProvinceModel *province in array) {
        [tmpArray addObject:province.p];
    }
    self.currentProvince = array[0];
    [self setProvinceButtonTitle];
    self.provinceArray = [NSArray arrayWithArray:tmpArray];
}


/**
 选择省份默认设置城市和地区
 */
- (void)setProvinceButtonTitle {
    
    EHCityModel *city = [self.currentProvince.c objectAtIndex:0];
    NSArray * nameArray = nil;
    if (city.a > 0) {
        EHAreaModel *area = [city.a objectAtIndex:0];
        nameArray = @[self.currentProvince.p, city.n, area.s];
    }else{
        nameArray = @[self.currentProvince.p, city.n];
    }
    
    for (int i = 0; i < nameArray.count; i++) {
        UIButton * button = [_areaView viewWithTag:100+i];
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
    }
    
    if (nameArray.count == 2) {
        UIButton * button = [_areaView viewWithTag:102];
        button.hidden = YES;
    }
}

/**
 选择城市后默认设置地区

 @param cName 城市名字
 */
- (void)setCityButtonTitleByCityName:(NSString *)cName {
    EHCityModel *cityModel = nil;
    for (EHCityModel *city in self.currentProvince.c) {
        if ([city.n isEqualToString:cName]) {
            cityModel = city;
            break;
        }
    }
    if (cityModel.a.count > 0) {
        EHAreaModel *area = [cityModel.a objectAtIndex:0];
        UIButton * button = [_areaView viewWithTag:102];
        [button setTitle:area.s forState:UIControlStateNormal];
    }
}

/**
 根据省份／城市 取下级数据

 @param name 省份／城市
 @return 字符串数组
 */
- (NSArray *)handleCityAndAreaDataByName:(NSString *)name {
    NSMutableArray * tmpArray = [NSMutableArray array];
    for (EHProvinceModel *province in self.areaArray) {
        if ([province.p isEqualToString:name]) {
            for (EHCityModel *city in province.c) {
                [tmpArray addObject:city.n];
            }
            break;
        }
    }
    return tmpArray;
}

/**
 根据城市 取下级数据

 @param provinceName 省份
 @param cityName 城市
 @return 地区字符串数组
 */
- (NSArray *)handleAreaDataByProvinceName:(NSString *)provinceName
                                 cityName:(NSString *)cityName {
    NSMutableArray * tmpArray = [NSMutableArray array];
    for (EHProvinceModel *province in self.areaArray) {
        if ([province.p isEqualToString:provinceName]) {
            for (EHCityModel *city in province.c) {
                if ([city.n isEqualToString:cityName]) {
                    for (EHAreaModel *area in city.a) {
                        [tmpArray addObject:area.s];
                    }
                    return tmpArray;
                }
            }
        }
    }
    return tmpArray;
}

#pragma mark -- UITableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHRegisterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHRegisterCell" forIndexPath:indexPath];
    cell.dict = self.dataSource[indexPath.row];
    if (indexPath.row == 0) {
        [cell.contentTextField becomeFirstResponder];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark -- Click Event

- (void)selectArea:(UIButton *)sender {
    
    self.alphaView.hidden = NO;
    self.areaSelectView.hidden = NO;
    
    DefineWeakSelf
    __block UIButton *button = sender;
    self.areaSelectView.clickBlock = ^(NSString *title) {
        [button setTitle:title forState:UIControlStateNormal];
        weakSelf.alphaView.hidden = YES;
        weakSelf.areaSelectView.hidden = YES;
        if (button.tag == 100) {
            [weakSelf searchCurrentProvinceModelByProvinceName:title];
            [weakSelf isHiddenAreaBtnByProvinceName:title];
            [weakSelf setProvinceButtonTitle];
        }else if (button.tag == 101) {
            [weakSelf setCityButtonTitleByCityName:title];
        }else{
            
        }
    };
    
    switch (sender.tag) {
        case 100:{
            [self setupAreaSelectViewHeightByArray:self.provinceArray];
            [self.areaSelectView reloadDataByArray:self.provinceArray];
        }
            break;
            
        case 101:{
            UIButton *provinceButton = [_areaView viewWithTag:100];
            NSArray *cityArray = [self handleCityAndAreaDataByName:provinceButton.currentTitle];
            [self setupAreaSelectViewHeightByArray:cityArray];
            [self.areaSelectView reloadDataByArray:cityArray];
        }
            break;

        case 102: {
            UIButton *provinceButton = [_areaView viewWithTag:100];
            UIButton *cityButton = [_areaView viewWithTag:101];
            NSArray * areas = [self handleAreaDataByProvinceName:provinceButton.currentTitle cityName:cityButton.currentTitle];
            [self setupAreaSelectViewHeightByArray:areas];
            [self.areaSelectView reloadDataByArray:areas];
        }
            break;

        default:
            break;
    }
}

/**
 蒙层点击事件
 */
- (void)alphaViewClick {
    self.alphaView.hidden = YES;
    self.areaSelectView.hidden = YES;
}

/**
 点击查看协议
 */
- (void)agreementBtnAction {
    DefineWeakSelf
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.protocolView.hidden = NO;
    }];
}

/**
 注册
 */
- (void)registerBtnAction {
        
    [MBProgressHUD showLoading:@"正在注册..." toView:self.view];
    NSArray *parmsArray = @[@"niceName", @"userName", @"email", @"pwd", @"pwd", @"invitecode"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.dataSource.count; i++) {
        NSString * placeholder = [self.dataSource[i] objectForKey:@"placeholder"];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        EHRegisterCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (![placeholder isEqualToString:@"输入邀请码"]) {
            if (cell.contentTextField.text.length == 0) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:placeholder toView:self.view];
                return;
            }
        }
        [params setObject:cell.contentTextField.text forKey:parmsArray[i]];
    }
    
    NSArray *cityKeyArray = @[@"province", @"city", @"area"];

    for (int i = 0; i < 3; i++) {
        UIButton * sender = [_areaView viewWithTag:100+i];
        if (sender.hidden == NO) {
            [params setObject:sender.currentTitle forKey:cityKeyArray[i]];
        }else{
            [params setObject:@"" forKey:cityKeyArray[i]];
        }
    }
    
    [self.netService registerDataWithParam:params successBlock:^(id obj) {
        
        NSString *code = [obj objectForKey:@"code"];
        // 这个接口要特殊处理，规则改成666666代表成功
        if ([code isEqualToString:@"666666"]) {
            NSDictionary * data = [obj objectForKey:@"data"];
            EHUserInfo *user = [EHUserInfo mj_objectWithKeyValues:data];
            [EHUserInfo loginWithData:user];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"恭喜您，注册成功" toView:self.view];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }

    } errorBlock:^(EHError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:error.msg toView:self.view];
    }];
}

/**
 设置地区选择试图的高和y
 */
- (void)setupAreaSelectViewHeightByArray:(NSArray *)array {
    
    CGFloat height = array.count * 40.f;
    if (height > (kScreenHeight - 80)) {
        self.areaSelectView.y = 40;
        self.areaSelectView.height = kScreenHeight - 64 - 80;
    }else{
        self.areaSelectView.height = height;
        self.areaSelectView.y = (kScreenHeight - 64 - height)/2;
    }
}

/**
 如果是直辖市 隐藏地区

 @param provinceName 省份名字
 */
- (void)isHiddenAreaBtnByProvinceName:(NSString *)provinceName {
    NSArray * array = @[@"北京", @"天津", @"澳门", @"重庆", @"台湾", @"上海"];
    UIButton *areaButton = [_areaView viewWithTag:102];

    if ([array containsObject:provinceName]) {
        areaButton.hidden = YES;
    }else{
        areaButton.hidden = NO;
    }
}


/**
 设置当前选中的省份

 @param pName 省份名字
 */
- (void)searchCurrentProvinceModelByProvinceName:(NSString *)pName {
    
    for (EHProvinceModel *item in self.areaArray) {
        if ([item.p isEqualToString:pName]) {
            self.currentProvince = item;
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
