//
//  EHTableViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2024/6/9.
//  Copyright © 2024 EnergyHub. All rights reserved.
//

#import "EHActivityListViewController.h"
#import "EHActivityItemCell.h"
#import "EHActivityDetailViewController.h"
#import "EHActivityTopView.h"
#import "EHHorizontalScrollView.h"
#import "UIImage+Extension.h"
#import "EHActivityItem.h"
#import <EnergyHub-Swift.h>
#import "EHActivityService.h"


@interface EHActivityListViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    EHActivityTopViewDelegate
>

@property(nonatomic, strong) NSArray *dataList;
@property (nonatomic, assign) CGFloat tabBarHeight;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EHActivityTopView *activityTopView;
@property (nonatomic, strong) EHHorizontalScrollView *horizontalScrollView;
@property (nonatomic, strong) EHActivityService *service;

@end

@implementation EHActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"同城活动";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FAFAF8"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    EHActivityItem *item = [[EHActivityItem alloc] init];
    item.url = @"https://img-qn.hudongba.com/jootun_common/1upload/image/202405/09/13/gfi8hu/1715232636452.png";
    item.activityName = @"HICOOL 2024全球创业者峰会\n即将再次引爆京城！";
    item.date = @"2024-07-23 09:30";
    item.price = @"免费";
    item.count = @"356人已报名";
    item.theme = ActivityThemeDuShuHui;
    item.tags = @[@(ActivityTagMianFei),@(ActivityTagMeiZiDuo),@(ActivityTagYouHuiZu)];
    
    self.dataList = @[item, item, item];
    [self.tableView registerNib:[UINib nibWithNibName:[EHActivityItemCell cellIdentifier] bundle:nil] forCellReuseIdentifier:[EHActivityItemCell cellIdentifier]];
    [self setupUI];
    [self loadList];
    self.needNav = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadList];
}

- (void) loadList {
    NSInteger userId = [[EHUserInfo sharedUserInfo].Id integerValue];
    NSDictionary *params = @{@"pageNum": @1, @"pageSize": @10, @"currentUserId": @(userId)};
    
    [self.service activityListWithParam:params successBlock:^(NSArray * _Nonnull courseArray) {
        // 处理接收到的活动列表 courseArray
        NSLog(@"Received activities: %@", courseArray);
    } errorBlock:^(EHError *error) {
        // 处理错误情况
        NSLog(@"Request failed with error: %@", error);
    }];
}

- (EHActivityTopView *)activityTopView {
    if (!_activityTopView) {
        _activityTopView = [[EHActivityTopView alloc] init];
        _activityTopView.delegate = self;
    }
    return _activityTopView;
}

- (void)setupUI {
    self.horizontalScrollView = [[EHHorizontalScrollView alloc] initWithFrame:CGRectZero activities:@[@"同城活动", @"同城活动", @"同城活动", @"同城活动", @"同城活动"]];
    self.horizontalScrollView.backgroundColor = [UIColor whiteColor];
    self.horizontalScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.activityTopView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.horizontalScrollView];
    [self.view addSubview:self.activityTopView];
    [self.horizontalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [self.activityTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.horizontalScrollView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40); // 仅占 `topView` 的高度
    }];
    [self.view bringSubviewToFront:self.activityTopView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activityTopView.whiteView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-self.tabBarHeight);
    }];
    

}

// 将 CAGradientLayer 渲染为 UIImage
- (UIImage *)imageFromLayer:(CAGradientLayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, [UIScreen mainScreen].scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewDidLayoutSubviews {
    self.horizontalScrollView.layer.masksToBounds = YES;
    [self.horizontalScrollView setCornerWithRadius:16.0 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#FAFAF8"];
        [self.view addSubview:_tableView];
        
        
    }
    return _tableView;
}

- (EHActivityService *)service {
    if (!_service) {
        _service = [[EHActivityService alloc] init];
    }
    return _service;
}

- (CGFloat)tabBarHeight {
    return self.tabBarController.tabBar.frame.size.height;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHActivityItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[EHActivityItemCell cellIdentifier]];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.itemData = self.dataList[indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EHActivityDetailViewController *controller = [EHActivityDetailViewController instance];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    [view setHidden:YES];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - 顶部选择器代理
- (void)didExpandSelection {
        [self.activityTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.horizontalScrollView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-self.tabBarHeight);
        }];
        [self.view layoutIfNeeded];
}

- (void)didCloseSelection {
        [self.activityTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.horizontalScrollView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(40);
        }];
        [self.view layoutIfNeeded];
}

- (void)didSelectAreaWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district {
    NSString *info = [NSString stringWithFormat:@"%@ - %@ - %@", province, city, district];
    NSLog(@"%@", info);
}

- (void)didSelectActivity:(NSString *)activity {
    NSLog(@"筛选活动%@", activity);
}

- (void)clickManageView {
    NSLog(@"点击活动管理");
}

- (void)clickReleaseView {
    NSLog(@"点击发布活动");
    EHActivityReleaseController *vc = [EHActivityReleaseController instance];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
