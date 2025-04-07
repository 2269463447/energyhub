//
//  EHOfflineViewController.m
//  EnergyHub
//
//  Created by gao on 2017/8/12.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHOfflineViewController.h"
#import "EHOfflineCourseCell.h"
#import "EHOfflineService.h"
#import "EHPlayVideoViewController.h"
#import "EHCacheManager.h"
#import <FCFileManager.h>
#import "UIViewController+Share.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface EHOfflineViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    EHCourseDownloadDelegate,
    DZNEmptyDataSetSource,
    DZNEmptyDataSetDelegate
>

@property (nonatomic, strong) EHOfflineService *offlineService;
@property (nonatomic, strong) NSMutableArray *listData;

// 有值表示需要下载，无值表示无下载任务
@property (nonatomic, copy) NSString *taskId;

@end

@implementation EHOfflineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self startLoadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateStatusForIdleTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self updateStatusForIdleTimer];
}

- (void)setupUI {

    self.view.backgroundColor = kBackgroundColor;
    RegisterCellToTable([EHOfflineCourseCell cellIdentifier], self.tableView)
    [self facilitateShare];
    // empty view
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    // 监听下载状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStatusForIdleTimer)
                                                 name:DownloadItemSuccessNotification
                                               object:nil];
}

- (void)startLoadData {
    
    DefineWeakSelf
    
    [self.offlineService loadOfflineCourseWithBlock:^(NSArray *courseList) {
        
        [weakSelf loadCourseListFinished:courseList];
    }];
}

- (void)loadCourseListFinished:(NSArray *)courseList {
    
    self.listData = [NSMutableArray array];
    
    for (EHCourseItem *item in courseList) {
        int pid = [item.courseId intValue];
        NSString *path = [[EHDownloadManager sharedManager] unzipPathOfProduct:pid];
        EHLog(@"zip path: %@, id: %d", path, pid);
        if (![FCFileManager existsItemAtPath:path]) {
            EHLog(@"########pid: %d nonexist", pid);
            item.retry = YES; // 筛选出下载失败的课程
        }
        [self.listData addObject:item];
    }
    [self.tableView reloadData];
    [self.tableView reloadEmptyDataSet];
}
             
- (void)downloadCourseWithId:(NSString *)courseId {
 
    _taskId = courseId;

    if (!_taskId) {
        [MBProgressHUD showError:@"数据错误" toView:self.view];
        return;
    }

    DefineWeakSelf

    NSDictionary *param = @{@"uid": [EHUserInfo sharedUserInfo].Id, @"tid": _taskId};

    [self.offlineService downloadCourseWithParam:param successBlock:^(EHOfflineData *offlineData) {
     
        if (offlineData) {
            // 开始下载视频
            [[EHDownloadManager sharedManager] downloadProduct:_taskId.intValue withURL:offlineData.strZipPath];
            EHCourseItem *item = [EHCacheManager objectForCachedKey:[NSString stringWithFormat:@"courseb_%@", _taskId]];
            item.downloading = YES;
            [weakSelf.listData addObject:item];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView reloadEmptyDataSet];
            [self keepDownloading:YES];// 禁止休眠
        }
     
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:@"获取下载地址出错!" toView:weakSelf.view];
    }];
}

#pragma mark - Custom Events

- (void)deleteCachedCourseAtRow:(NSInteger)row {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该视频？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        
        [MBProgressHUD showLoading:@"正在删除..." toView:self.view];
        EHCourseItem *item = self.listData[row];
        NSString *path = [[EHDownloadManager sharedManager] unzipPathOfProduct:[item.courseId intValue]];
        NSError *error;
        if ([FCFileManager existsItemAtPath:path]) {
            [FCFileManager removeItemAtPath:path error:&error];
        }
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (error) {
            EHLog(@"删除缓存失败, path: %@", path);
            [MBProgressHUD showError:@"删除失败" toView:self.view];
        }else {
            EHCourseItem *item = self.listData[row];
            NSString *cachedKey = [NSString stringWithFormat:@"offline_%@", item.courseId];
            [EHCacheManager removeObjectForKey:cachedKey];
            [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
        }
        // reload
        [self.listData removeObjectAtIndex:row];
        [self.tableView reloadData];
        [self.tableView reloadEmptyDataSet];
    }];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)didClickedRetryButtonWithId:(int)pid {
    
    if (pid <= 0) {
        [MBProgressHUD showError:@"下载失败" toView:self.view];
        return;
    }
    [self keepDownloading:YES];
    NSString *cachedKey = [NSString stringWithFormat:@"offline_%d", pid];
    EHOfflineData *offline = [EHCacheManager objectForCachedKey:cachedKey];
    [[EHDownloadManager sharedManager] downloadProduct:pid withURL:offline.strZipPath];
}

- (void)keepDownloading:(BOOL)keep {
    
    if (keep) {
        if (![[UIApplication sharedApplication] isIdleTimerDisabled]) {
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
    }else {
        if ([[UIApplication sharedApplication] isIdleTimerDisabled]) {
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        }
    }
}

- (void)updateStatusForIdleTimer {
    
    for (EHCourseItem *item in _listData) {
        if (item.downloading) {
            [self keepDownloading:YES];
            return;
        }
    }
    // 开启自动休眠
    [self keepDownloading:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EHOfflineCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:[EHOfflineCourseCell cellIdentifier]];
    cell.dataModel = self.listData[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [EHOfflineCourseCell cellHeight];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteCachedCourseAtRow:indexPath.row];
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EHCourseItem *itemData = self.listData[indexPath.row];
    if (itemData.downloading) {
        [MBProgressHUD showError:@"正在下载，请稍后" toView:self.view];
    }else if (itemData.unzipping) {
        [MBProgressHUD showError:@"正在解压，请稍后" toView:self.view];
    }else {
        EHPlayVideoViewController *playVC = [[EHPlayVideoViewController alloc] init];
        playVC.cid = itemData.courseId;
        playVC.playType = EHPlayTypeOffline;
        NSString *cachedKey = [NSString stringWithFormat:@"offline_%@", itemData.courseId];
        playVC.offlineData = [EHCacheManager objectForCachedKey:cachedKey];
        playVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:playVC animated:YES completion:nil];
    }
}

#pragma mark - DZNEmptyDataSetSource and Delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"cache_empty"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [[NSAttributedString alloc]initWithString:@"缓存课程,随时随地可离线观看"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return 10.f;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    
    return 40.f;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.listData.count <= 0;
}

#pragma mark - Getter

- (EHOfflineService *)offlineService {
    if (!_offlineService) {
        _offlineService = [[EHOfflineService alloc]init];
    }
    return _offlineService;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
