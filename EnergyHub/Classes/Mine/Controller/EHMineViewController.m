//
//  EHMineViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/12.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHMineViewController.h"
#import "EHMemberWatchVideoViewController.h"
#import "EHRecordsOfConsumptionViewController.h"
#import "EHBeATeacherViewController.h"
#import "EHLoginViewController.h"
#import "EHHelpViewController.h"
#import "EHMineHeaderCell.h"
#import "EHMineCell.h"
#import "EHUserInfo.h"
#import "EHMineService.h"
#import "JEPhotographyHelper.h"

@interface EHMineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataSource;
@property (strong, nonatomic) EHMineService *service;

@end

@implementation EHMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    // 监听登录状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess) name:LogoutSuccessNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        EHMineHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHMineHeaderCell" forIndexPath:indexPath];
        [cell loadUserInfo];
        cell.loginBlock = ^(UIButton *sender) {
            EHLoginViewController *loginVC = [[EHLoginViewController alloc] init];
            loginVC.title = @"登录";
            [self.navigationController pushViewController:loginVC animated:YES];
        };
        cell.avatarBlock = ^(UIButton *sender) {
            if (![EHUserInfo sharedUserInfo].isLogin) {
                EHLoginViewController *loginVC = [[EHLoginViewController alloc] init];
                loginVC.title = @"登录";
                [self.navigationController pushViewController:loginVC animated:YES];
            }else {
                [self changeAvatar];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    EHMineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHMineCell" forIndexPath:indexPath];
    cell.data = self.dataSource[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section ? 50 : 260;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;//section > 0 ? 6.f : 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dataSource = _dataSource[indexPath.section];
    BOOL needToken = [dataSource[@"token"] boolValue];
    
    if (needToken && ![EHUserInfo sharedUserInfo].isLogin) {
//        [MBProgressHUD showError:@"请登录" toView:self.view];
        EHLoginViewController *login = [EHLoginViewController instance];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    BOOL needRole = [dataSource[@"role"] boolValue];
    if (needRole && ![[EHUserInfo sharedUserInfo] isTeacher]) {
        [MBProgressHUD showError:@"您还不是教师" toView:self.view];
        return;
    }
    
    NSString *className = [dataSource objectForKey:@"class"];
    if (!className) {
        return;
    }
    // 根据类名创建VC
    Class clazz = NSClassFromString(className);
    UIViewController *toController = [clazz instance];
    
    if ([toController isKindOfClass:[UIViewController class]]) {
        toController.title = dataSource[@"title"];
        toController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:toController animated:YES];
    }
}

#pragma mark - LoginSuccessNotification

- (void)loginSuccess {
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    EHMineHeaderCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell updateUserInfo];
}

- (void)logoutSuccess {
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    EHMineHeaderCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell loadUserInfo];
}


- (void)changeAvatar {
    
    DefineWeakSelf
    
    JETakeMediaCompletionBlock pickerMediaBlock = ^(UIImage *image, NSDictionary *editingInfo) {
        if (image) {
            EHBaseParam *imageParam = [EHBaseParam param];
            // 如果是从相册中选取，读取相册中的图片，如果是拍照，直接使用image
            NSURL *imageUrl = editingInfo[UIImagePickerControllerReferenceURL];
            // 如果是拍照imageUrl为空， block也会调用，参数为nil，此时使用image，默认JPEG格式
            [Utils readImageDataFromPhotoLibraryWithURL:imageUrl success:^(NSData *data, NSString *filename) {
                [MBProgressHUD showLoading:@"正在上传..." toView:weakSelf.view];
                [weakSelf.service updateAvatarImageWithParam:imageParam.mj_keyValues image:image imageData:data filename:filename successBlock:^(NSString *avatarImage) {
                    if (avatarImage) {
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:AvatarUpdatedNotification object:nil userInfo:@{@"avatar": avatarImage}];
                        // 更新缓存
                        [EHUserInfo sharedUserInfo].picture = avatarImage;
                        [EHUserInfo updateUserData];
                    } else {
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        [MBProgressHUD showError:@"头像更新失败,请重试" toView:weakSelf.view];
                    }
                } errorBlock:^(EHError *error) {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    [MBProgressHUD showError:@"头像更新失败,请重试" toView:weakSelf.view];
                }];
            }];
        } else {
            if (!editingInfo)
                return;
        }
    };
    
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:@"相机拍照" handler:^{
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alertView =
            [UIAlertView bk_alertViewWithTitle:@"提示"
                                       message:@"能量库需要访问您的摄像头。\n请启用相册访问权限-设置/隐私/相机"];
            [alertView bk_addButtonWithTitle:@"提示" handler:nil];
            [alertView show];
            return;
        }
        [JEPhotographyHelper showAvatarPickerIn:weakSelf sourceType:UIImagePickerControllerSourceTypeCamera completionHandler:pickerMediaBlock];
    }];
    [actionSheet bk_addButtonWithTitle:@"从相册选择" handler:^{
        [JEPhotographyHelper showAvatarPickerIn:weakSelf sourceType:UIImagePickerControllerSourceTypePhotoLibrary completionHandler:pickerMediaBlock];
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"确定" handler:nil];
    [actionSheet showInView:self.view];
}

#pragma mark -- Getter

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect bounds = self.view.bounds;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -24, bounds.size.width, bounds.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"EHMineHeaderCell" bundle:nil] forCellReuseIdentifier:@"EHMineHeaderCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"EHMineCell" bundle:nil] forCellReuseIdentifier:@"EHMineCell"];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
}

- (EHMineService *)service {
    if (!_service) {
        _service = [[EHMineService alloc] init];
    }
    return _service;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        /* token=1 需要登录， role=1 需要教师权限 class：需要跳转的界面 */
        _dataSource = @[@{@"title" : @"header",
                          @"imgName" : @""},
                        /*
                        @{@"title" : @"我的销售团队",
                          @"imgName" : @"team",
                          @"token": @1, @"role": @0,
                          @"class": @"EHTeamDetailViewController"},*/
                        @{@"title" : @"我的消费记录",
                          @"imgName" : @"record",
                          @"token": @1, @"role": @0,
                          @"class": @"EHRecordsOfConsumptionViewController"},
                        @{@"title" : @"我要成为能量库教育网的老师并发布视频",
                          @"imgName" : @"user",
                          @"token": @1, @"role": @0,
                          @"class": @"EHBeATeacherViewController"},
                        @{@"title" : @"充值U币",
                          @"imgName" : @"charge",
                          @"token": @1, @"role": @0,
                          @"class": @"EHRechargeViewController"},

                        @{@"title" : @"帮助信息",
                          @"imgName" : @"help",
                          @"token": @0, @"role": @0,
                          @"class": @"EHHelpViewController"},
                        @{@"title" : @"会员信息修改",
                          @"imgName" : @"write",
                          @"token": @1, @"role": @0,
                          @"class": @"EHUserInfoModifyViewController"},
                        @{@"title" : @"我的发布",
                          @"imgName" : @"release",
                          @"token": @1, @"role": @1,
                          @"class": @"EHReleasedCourseViewController"},
                        @{@"title" : @"会员如何免费看视频",
                          @"imgName" : @"members",
                          @"token": @0, @"role": @0,
                          @"class": @"EHMemberWatchVideoViewController"},
                        @{@"title" : @"同城服务",
                          @"imgName" : @"code",
                          @"token": @0, @"role": @0,
                          @"class": @"EHActivityEntryViewController"}];
        
    }
    return _dataSource;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
