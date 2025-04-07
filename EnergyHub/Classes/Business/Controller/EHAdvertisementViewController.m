//
//  EHAdvertisementViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/13.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHAdvertisementViewController.h"
#import "EHAdvertisementCell.h"
#import "UIViewController+Share.h"

static NSString * cellIdentifier = @"EHAdvertisementCell";

@interface EHAdvertisementViewController ()<UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * dataSource;

@end

@implementation EHAdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self facilitateShare];
}

- (void)setupUI {
    self.view.backgroundColor = kBackgroundColor;
    self.tableView.rowHeight = 115;
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"EHAdvertisementCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark -- getter

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@{@"title":@"一、商业合作",
                          @"content":@"如果你想与本公司通过资源置换、异业合作、战略合作等，从而达到共赢，请与我们联系！请将你的资料和设想提交以下邮箱：cafhj112@163.com"},
                        @{@"title":@"二、媒体合作",
                          @"content":@"如果你们是媒体单位，如需要本站配合你们开展各类活动，请与我们联系！相关资料和详情内容发至以下邮箱：cafhj112@163.com"},
                        @{@"title":@"三、软件合作",
                          @"content":@"如果你想通过本网站推广你优秀的软件（PC类、APP类等等），请与我们联系！相关资料和详情内容发至以下邮箱：cafhj112@163.com"},
                        @{@"title":@"四、收量合作",
                          @"content":@"如果你想通过推广本公司旗下产品而获得收入，请与我们联系！相关资料发至以下邮箱：zgfhj112@163.com"},
                        @{@"title":@"五、广告合作",
                          @"content":@"如果你想和本站进行广告方面的合作，请与我们联系！相关资料和详情内容发至以下邮箱：zgfhj112@163.com"},
                        @{@"title":@"六、新闻合作",
                          @"content":@"如果你想对本站进行预约采访，信息索取、参观交流、消息核实等工作，请与我们联系!相关资料和详情内容发至以下邮箱：zgfhj112@163.com"}];
    }
    return _dataSource;
}

#pragma mark -- UITableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHAdvertisementCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.dict = self.dataSource[indexPath.section];
    cell.backgroundColor = kBackgroundColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
