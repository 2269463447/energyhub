//
//  EHCourseListViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/21.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHCourseListViewController.h"
#import "EHCacheManager.h"
#import "EHHomeService.h"
#import "EHCourseListCell.h"
#import "EHCourseTitleHeader.h"
#import "EHPlayVideoViewController.h"
#import "UIViewController+Share.h"

@interface EHCourseListViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) EHHomeService *homeService;
@property (nonatomic, strong) NSMutableArray *listData;

@end

@implementation EHCourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self startLoadData];
}

- (void)setupUI {
    self.view.backgroundColor = kBackgroundColor;
    RegisterCellToTable([EHCourseListCell cellIdentifier], self.tableView)
    // header
    [self.tableView registerClass:[EHCourseTitleHeader class] forHeaderFooterViewReuseIdentifier:@"EHCourseTitleHeader"];
    // share and setting
    [self facilitateShareAndSetting];
}

- (void)startLoadData {
    
    if (!self.categoryId) {
        [MBProgressHUD showError:@"课程不存在" toView:self.view];
        return;
    }
    
    DefineWeakSelf
    
    [self.homeService courseListWithParam:@{@"aid": self.categoryId} successBlock:^(NSArray *courseList) {
        [weakSelf loadCourseListFinished:courseList];
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

- (void)loadCourseListFinished:(NSArray *)courseList {
    
    self.listData = [NSMutableArray arrayWithArray:courseList];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.listData.count > 0 ? (self.listData.count + 1) : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    EHCourseListData *courseData = self.listData[section - 1];
    return courseData.typecs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        return [UITableViewCell new];
    }
    EHCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:[EHCourseListCell cellIdentifier]];
    EHCourseListData *courseData = self.listData[indexPath.section - 1];
    cell.itemData = courseData.typecs[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.listData.count > 0 && section == 0) {
        return nil;
    }
    EHCourseTitleHeader *titleHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"EHCourseTitleHeader"];
    titleHeader.dataModel = self.listData[section - 1];
    return titleHeader;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listData.count > 0 && indexPath.section == 0) {
        return 0.1f;
    }
    return [EHCourseListCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.listData.count > 0 && section == 0) {
        return 0.01f;
    }
    return [EHCourseTitleHeader cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 8.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8.f)];
    footer.backgroundColor = EHSeparatorColor;
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EHCourseListData *courseData = self.listData[indexPath.section-1];
    EHCourseItem *itemData = courseData.typecs[indexPath.row];
    EHPlayVideoViewController *playVC = [[EHPlayVideoViewController alloc] init];
    playVC.cid = itemData.courseId;
    playVC.modalPresentationStyle = UIModalPresentationFullScreen; // ios13默认是PageSheet
    EHLog(@"cid-->%@", itemData.courseId);
    // 缓存
    NSString *cacheKey = [NSString stringWithFormat:@"courseb_%@", itemData.courseId];
    if (![EHCacheManager hasObjectForCachedKey:cacheKey]) {
        [EHCacheManager cacheObject:itemData forKey:cacheKey];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSString stringWithFormat:@"%@ %@", self.title, itemData.name] forKey:@"courseAll"];
    [ud synchronize];
    [self presentViewController:playVC animated:YES completion:nil];
}

#pragma mark - Getter

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
    
    EHLog(@"%@ is deallocing.", [self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
