//
//  EHHomeViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/12.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHHomeViewController.h"
#import "EHHomeService.h"
#import "EHBannerView.h"
#import "EHHomeCourseCell.h"
#import "EHHomeRecommendCell.h"
#import "UIViewController+Share.h"
#import "EHCourseListViewController.h"
#import "EHMessageListViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "EHLoginViewController.h"
#import "EHMineService.h"

const NSUInteger kUnreadTag = 100;

@interface EHHomeViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    DZNEmptyDataSetSource,
    DZNEmptyDataSetDelegate
>

@property (nonatomic, strong) EHBannerView *bannerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EHHomeService *homeService;
@property (nonatomic, strong) EHMineService *tmpUsetService;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) EHHomeBannerData *bannerData;
@property (nonatomic, strong) UIButton *messageButton;
// 是否初始化完成，用来决定emptyDataSet是否显示
@property (nonatomic, assign) BOOL isInited;

@end

@implementation EHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self startLoadData];
    [self requestTmpUserAccount];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateMessageStatus];
}

- (void)setupUI {
    self.view.backgroundColor = kBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"EHHomeCourseCell" bundle:nil] forCellReuseIdentifier:@"EHHomeCourseCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHHomeRecommendCell" bundle:nil] forCellReuseIdentifier:@"EHHomeRecommendCell"];
    // message
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    // 设置按钮的尺寸为背景图片的尺寸
    messageButton.size = messageButton.currentBackgroundImage.size;
    // 监听按钮点击
    [messageButton addTarget:self action:@selector(readMessage) forControlEvents:UIControlEventTouchUpInside];
    self.messageButton = messageButton;
    // unread
    UIImageView *unread = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"unread"]];
    unread.tag = kUnreadTag;
    unread.width = unread.height = 8;
    unread.x = messageButton.right - 9 + unread.width * .5;
    unread.y = - unread.height * .5 + 3;
    [messageButton addSubview:unread];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    // 分享与设置
    [self facilitateShareAndSetting];
    // 监听登录状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageStatus) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeMessageStatus) name:LogoutSuccessNotification object:nil];
    // empty view
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)markNewMessage:(NSInteger)has {
    
    UIImageView *unread = [self.messageButton viewWithTag:kUnreadTag];
    unread.hidden = has; // 0表示有新消息，1表示没有消息；目前不支持多条消息的状态
}

- (void)resumeMessageStatus {
    
    [self markNewMessage:0];
}

- (void)updateMessageStatus {
    
    DefineWeakSelf
    if ([EHUserInfo sharedUserInfo].isLogin) {
        // 消息状态
        [self.homeService messageStatusWithParam:@{} successBlock:^(NSInteger code) {
            [weakSelf markNewMessage:code];
        } errorBlock:^(EHError *error) {
            [MBProgressHUD showError:error.msg toView:weakSelf.view];
        }];
    }
}

- (void)startLoadData {
    
    DefineWeakSelf
    [self.homeService homeBannerDataWithParam:@{} successBlock:^(EHHomeBannerData *bannerData) {
        [weakSelf loadBannerFinished:bannerData];
    } errorBlock:^(EHError *error) {
        weakSelf.isInited = YES;
        [weakSelf.tableView reloadEmptyDataSet];
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

- (void)loadBannerFinished:(EHHomeBannerData *)bannerData {
    _bannerData = bannerData;
    // banner
    self.bannerView.adList = [bannerData bannerImages];
    // 推荐
    if ([bannerData hasRecommend]) {
        [self.sectionArray addObject:[EHHomeRecommendCell cellIdentifier]];
    }
    DefineWeakSelf
    // 加载课程
    [self.homeService homeCourseListWithParam:@{} successBlock:^(NSArray *courseList) {
        
        [weakSelf loadCourseListFinished:courseList];
        
    } errorBlock:^(EHError *error) {
        weakSelf.isInited = YES;
        [weakSelf.tableView reloadEmptyDataSet];
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

- (void)loadCourseListFinished:(NSArray *)courseList {
    
    self.listData = [NSMutableArray arrayWithArray:courseList];
    
    EHHomeCourseData *menuData = [[EHHomeCourseData alloc]init];
    menuData.isMenu = YES;
    menuData.name = @"课程分类";
    menuData.img = @"course_menu";
    [self.listData insertObject:menuData atIndex:0];
    
    for (__unused EHHomeCourseData *_ in self.listData) {
        [self.sectionArray addObject:[EHHomeCourseCell cellIdentifier]];
    }
    [self.tableView reloadData];
    self.isInited = YES;
    [self.tableView reloadEmptyDataSet];
}

- (void)requestTmpUserAccount {
    [self.tmpUsetService tmpUserLoginSuccessBlock:^(NSDictionary * response) {
        NSDictionary *data = response[@"data"];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:data[@"account"] forKey:@"tmpAccount"];
        [ud setObject:data[@"pwd"] forKey:@"tmpPwd"];
        [ud setObject:data[@"yesOrNo"] forKey:@"tmpIsShow"];
        [ud synchronize];
    } errorBlock:^(EHError *error) {
        
    }];
}

#pragma mark - Custom Events

- (void)readMessage {
    if(![EHUserInfo sharedUserInfo].isLogin) {
//        [MBProgressHUD showError:@"请先登录" toView:self.view];
        EHLoginViewController *login = [EHLoginViewController instance];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    EHMessageListViewController *messageController = [EHMessageListViewController instance];
    [self.navigationController pushViewController:messageController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.bannerData ? (self.listData.count + 1) : self.listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self.sectionArray objectAtIndex:indexPath.section];
    if ([cellIdentifier isEqualToString:[EHHomeRecommendCell cellIdentifier]]) {
        EHHomeRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:[EHHomeRecommendCell cellIdentifier]];
        cell.bannerData = self.bannerData;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([cellIdentifier isEqualToString:[EHHomeCourseCell cellIdentifier]]) {
        EHHomeCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:[EHHomeCourseCell cellIdentifier]];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.courseData = self.listData[indexPath.section - 1];
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self.sectionArray objectAtIndex:indexPath.section];
    if ([cellIdentifier isEqualToString:[EHHomeRecommendCell cellIdentifier]]) {
        
        return [EHHomeRecommendCell cellHeight];
        
    }else if ([cellIdentifier isEqualToString:[EHHomeCourseCell cellIdentifier]]) {
        
        return [EHHomeCourseCell cellHeight];
    }
    return [EHBaseTableViewCell cellHeight];
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 8.f;
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *cellIdentifier = [self.sectionArray objectAtIndex:indexPath.section];
    if ([cellIdentifier isEqualToString:[EHHomeRecommendCell cellIdentifier]]) {
        //[MBProgressHUD showError:@"此链接暂无内容" toView:self.view];
        return;
    }
    
    EHHomeCourseData *courseData = [self.listData objectAtIndex:indexPath.section - 1];
    if (courseData.isMenu) {
        return;
    }
    EHCourseListViewController *courseListVC = [EHCourseListViewController instance];
    courseListVC.title = courseData.name;
    courseListVC.categoryId = courseData.courseId;
    [self.navigationController pushViewController:courseListVC animated:YES];
}

#pragma mark - DZNEmptyDataSetSource and Delegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self startLoadData];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"reload"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [[NSAttributedString alloc]initWithString:@"加载失败,请检查网络后重试"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return -40.f;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    
    return 5.f;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.isInited && self.listData.count <= 0;
}

#pragma mark - Getter

- (EHBannerView *) bannerView {
    if (!_bannerView) {
        _bannerView = [EHBannerView bannerView];
//        [self.view addSubview:_bannerView];
    }
    return _bannerView ;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 96, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 96, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.bannerView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (EHHomeService *)homeService {
    if (!_homeService) {
        _homeService = [[EHHomeService alloc]init];
    }
    return _homeService;
}

- (EHMineService *)tmpUsetService {
    if (!_tmpUsetService) {
        _tmpUsetService = [[EHMineService alloc] init];
    }
    return _tmpUsetService;
}

- (NSMutableArray *)listData {
    if (!_listData) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}

- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

#pragma mark - Memory

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
