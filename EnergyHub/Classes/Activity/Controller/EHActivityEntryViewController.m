//
//  EHCityActivityController.m
//  EnergyHub
//
//  Created by gaojuyan on 2024/6/2.
//  Copyright © 2024 EnergyHub. All rights reserved.
//

#import "EHActivityEntryViewController.h"
#import "EHActivityListViewController.h"

@interface EHActivityEntryViewController()

@property(nonatomic, strong) NSArray *dataList;

@end

@implementation EHActivityEntryViewController

- (void)commonInit {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EHActivityListViewController *controller = [[EHActivityListViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (NSArray*)dataList {
    if (_dataList == nil) {
        _dataList = @[@"同城活动", @"房屋租赁", @"招聘工作"];
    }
    return _dataList;
}

@end
