//
//  EHUserInfoModifyViewController.m
//  EnergyHub
//
//  Created by fanzhou on 2017/9/10.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHUserInfoModifyViewController.h"
#import "EHHomeService.h"

#define kUserInfoModifyItems @[@{@"title": @"昵称修改", @"class": @"EHUserInfoNicknameViewController"}, \
                               @{@"title": @"密码修改", @"class": @"EHUserInfoPasswordViewController"}, \
                               @{@"title": @"个性签名", @"class": @"EHUserInfoPersonalSignViewController"}, \
                               @{@"title": @"性别修改", @"class": @"sex"}, \
                               @{@"title": @"邮箱修改", @"class": @"EHUserInfoEmailViewController"} \
                              ]

@interface EHUserInfoModifyViewController ()

@property (nonatomic, strong) EHHomeService *service;

@end

@implementation EHUserInfoModifyViewController

#pragma mark - Life Cycle Methods

- (void) viewDidLoad {
    [super viewDidLoad] ;
    // 加载UI
    [self setupUI] ;
}

#pragma mark - Private Methods

- (void) setupUI {
    self.title = @"会员信息修改";
    self.tableView.backgroundColor = kBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    self.tableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return kUserInfoModifyItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UIView *selectedBackground = [UIView new];
    cell.backgroundColor = kBackgroundColor;
    cell.textLabel.textColor = EHFontColor;
    selectedBackground.backgroundColor = EHMainColor;
    cell.selectedBackgroundView = selectedBackground;
    // data
    NSDictionary *dataSource = kUserInfoModifyItems[indexPath.row];
    cell.textLabel.text = [dataSource objectForKey:@"title"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 调整文字与图标的距离
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dataSource = kUserInfoModifyItems[indexPath.row];
    NSString *className = [dataSource objectForKey:@"class"];
    if ([className isEqualToString:@"sex"]) {
        // 设置性别
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择性别" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DefineWeakSelf
            NSDictionary *param = @{@"id":[EHUserInfo sharedUserInfo].Id,
                                    @"sex":@"M"
                                    };
            [self.service modifySexWithParam:param successBlock:^(NSString *message) {
                if (message == nil) {
                    [MBProgressHUD showSuccess:@"修改成功" toView:weakSelf.view];
                }else {
                    [MBProgressHUD showError:message toView:weakSelf.view];
                }
            } errorBlock:^(EHError *error) {
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DefineWeakSelf
            NSDictionary *param = @{@"id":[EHUserInfo sharedUserInfo].Id,
                                    @"sex":@"F"
                                    };
            [self.service modifySexWithParam:param successBlock:^(NSString *message) {
                if (message == nil) {
                    [MBProgressHUD showSuccess:@"修改成功" toView:weakSelf.view];
                }else {
                    [MBProgressHUD showError:message toView:weakSelf.view];
                }
            } errorBlock:^(EHError *error) {
            }];
        }]];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    // 根据类名创建VC
    Class clazz = NSClassFromString(className);
    UIViewController *toController = [clazz instance];
    if ([toController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:toController animated:YES];
    }
}

#pragma mark - Getter

- (EHHomeService *)service
{
    if (!_service) {
        _service = [[EHHomeService alloc] init];
    }
    return _service;
}

@end
