#import "EHActivityTopView.h"
#import "Masonry.h"
#import "EHAreaCell.h"
#import "EHActivityCell.h"

@interface EHActivityTopView () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *containerView; // TableView 容器
@property (nonatomic, strong) UIView *activityView;  // CollectionView 容器
@property (nonatomic, strong) UIButton *locationBtn; // 显示选中省市区的按钮
@property (nonatomic, strong) UIButton *activityBtn; //活动筛选的按钮
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;  // 当前选中的按钮

@property (nonatomic, strong) NSArray *activityTitles;
@property (nonatomic, strong) UICollectionView *activityCollectionView;

@property (nonatomic, strong) UITableView *provinceTableView;  //省
@property (nonatomic, strong) UITableView *cityTableView;   //市
@property (nonatomic, strong) UITableView *districtTableView;   //区

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSMutableDictionary *cities;
@property (nonatomic, strong) NSMutableDictionary *districts;

@property (nonatomic, strong) NSArray *currentCities;
@property (nonatomic, strong) NSArray *currentDistricts;

@property (nonatomic, copy) NSString *selectedProvince;
@property (nonatomic, copy) NSString *selectedCity;
@property (nonatomic, copy) NSString *selectedDistrict;

@property (nonatomic, assign) BOOL isAreaExpanded;  //地区选择展开
@property (nonatomic, assign) BOOL isActivityExpend;  //活动展开
@property (nonatomic, assign) BOOL showCity;  //显示市列表
@property (nonatomic, assign) BOOL showDistrict;  //显示区列表

@property (nonatomic, strong) UIImageView *areaIcon;
@property (nonatomic, strong) UIImageView *activityIcon;

@property (nonatomic, strong) UILabel *areaLabel; //显示选择的地区
@property (nonatomic, strong) UILabel *activityLabel;  //显示筛选的活动


@end

@implementation EHActivityTopView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadData];
        [self setupUI];
    }
    return self;
}

#pragma mark - 加载数据
- (void)loadData {
    // 获取 JSON 文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"region_tree_data" ofType:@"json"];
    
    // 从文件中读取数据
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    
    // 解析 JSON 数据
    NSArray *regions = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    // 错误处理
    if (error) {
        NSLog(@"Error parsing JSON: %@", error.localizedDescription);
        return;
    }

    self.activityTitles = @[@"全部", @"创业路演",@"驴友出行",@"兴趣培养", @"聚会交友", @"技能体验", @"运动健身",@"商业促销"];
    // 你可以在这里进一步处理 `regions` 数据并将其转换为需要的 `provinces`, `cities`, `districts` 数据结构
    [self processRegions:regions];
}

- (void)processRegions:(NSArray *)regions {
    self.provinces = @[@"全部"];
    self.cities = [NSMutableDictionary dictionaryWithObject:@[] forKey:@"全部"];
    self.districts = [NSMutableDictionary dictionary];
    
    for (NSDictionary *province in regions) {
        NSString *provinceName = province[@"text"];
        self.provinces = [self.provinces arrayByAddingObject:provinceName];
        
        NSMutableArray *cityList = [NSMutableArray arrayWithObject:@"全部"];
        NSMutableDictionary *districtList = [NSMutableDictionary dictionary];
        
        NSArray *cities = province[@"children"];
        for (NSDictionary *city in cities) {
            NSString *cityName = city[@"text"];
            [cityList addObject:cityName];
            
            NSMutableArray *districts = [NSMutableArray arrayWithObject:@"全部"];
            NSArray *districtsData = city[@"children"];
            for (NSDictionary *district in districtsData) {
                NSString *districtName = district[@"text"];
                [districts addObject:districtName];
            }
            districtList[cityName] = districts;
        }
        
        // 更新 cities 字典
        self.cities[provinceName] = cityList;
        
        // 合并 districtList 到 districts 字典
        [self.districts addEntriesFromDictionary:districtList];
    }
    self.selectedProvince = self.provinces.firstObject;
    self.currentCities = self.cities[self.selectedProvince];
    self.selectedCity = self.currentCities.firstObject;
    self.currentDistricts = self.districts[self.selectedCity];
    self.selectedDistrict = self.currentDistricts.firstObject;
 
}


#pragma mark - UI
- (void)setupUI {
#pragma mark - 地址选择
    self.isAreaExpanded = NO;
    self.showCity = NO;
    self.showDistrict = NO;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    UIView *gradientView = [[UIView alloc] init];
    gradientView.backgroundColor = [UIColor colorWithHexString:@"#FFFCFA"];
    _whiteView = [[UIView alloc] init];
    _whiteView.backgroundColor = [UIColor whiteColor];
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.locationBtn addTarget:self action:@selector(toggleAreaSelection) forControlEvents:UIControlEventTouchUpInside];
    self.areaLabel = [self createLabel:@"地区选择"];
    self.areaIcon = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"icon_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    self.areaIcon.tintColor = [UIColor colorWithHexString:@"#333333"];
    [self.locationBtn addSubview:self.areaLabel];
    [self.locationBtn addSubview:self.areaIcon];
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.locationBtn);
    }];
    [self.areaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.areaLabel.mas_right);
            make.centerY.equalTo(self.areaLabel);
            make.right.equalTo(self.locationBtn);
    }];
    
    [self addSubview:_whiteView];
    [_whiteView addSubview:self.locationBtn];

    // 容器视图（超出 `EHActivityTopView` 的范围）
    self.containerView = [[UIView alloc] init];
    self.containerView.alpha = 0;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    [self.containerView addSubview:gradientView];
    

    // 创建 TableViews
    self.provinceTableView = [self createTableView];
    self.cityTableView = [self createTableView];
    self.districtTableView = [self createTableView];

    [self.containerView addSubview:self.provinceTableView];
    [self.containerView addSubview:self.cityTableView];
    [self.containerView addSubview:self.districtTableView];

    // 布局

    CGFloat tbvWidth = kScreenWidth / 3;
    
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_whiteView).offset(12);
        make.centerY.equalTo(_whiteView);
    }];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
    }];

    [self.provinceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.containerView);
        make.width.mas_equalTo(tbvWidth-30);
        make.bottom.equalTo(self.containerView).offset(-5);
    }];

    [self.cityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
        make.left.equalTo(self.provinceTableView.mas_right);
        make.width.mas_equalTo(tbvWidth);
        make.bottom.equalTo(self.containerView).offset(-5);
    }];

    [self.districtTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
        make.left.equalTo(self.cityTableView.mas_right);
        make.width.mas_equalTo(tbvWidth+30);
        make.bottom.equalTo(self.containerView).offset(-5);
    }];
    
    [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.containerView);
        make.left.equalTo(self.cityTableView);
    }];
    
#pragma mark - 活动筛选
    self.isActivityExpend = NO;
    self.activityBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.activityBtn addTarget:self action:@selector(toggleActivitySelection) forControlEvents:UIControlEventTouchUpInside];
    
    self.activityView = [[UIView alloc] init];
    self.activityView.backgroundColor = [UIColor whiteColor];
    self.activityView.alpha = 0;
    self.activityView.layer.masksToBounds = YES;
    
    self.activityLabel = [self createLabel:@"活动筛选"];;
    self.activityIcon = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"icon_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    self.activityIcon.tintColor = [UIColor colorWithHexString:@"#333333"];
    [self.activityBtn addSubview:self.activityLabel];
    [self.activityBtn addSubview:self.activityIcon];
    [self.activityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.activityBtn);
    }];
    [self.activityIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.activityLabel.mas_right);
            make.centerY.equalTo(self.activityLabel);
            make.right.equalTo(self.activityBtn);
    }];
    
    [_whiteView addSubview:self.activityBtn];
    [self.activityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationBtn.mas_right).offset(8);
        make.centerY.equalTo(_whiteView);
    }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;  // 水平滚动
    layout.sectionInset = UIEdgeInsetsMake(8, 12, 8, 12);
    layout.minimumLineSpacing = 13;  // 每行之间的间距
    layout.minimumInteritemSpacing = 12;  // 每个项之间的间距
    CGFloat itemWidth = (kScreenWidth - 65) / 4;
    layout.itemSize = CGSizeMake(itemWidth, 40);  // 每个按钮的大小
        
    self.activityCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.activityCollectionView.delegate = self;
    self.activityCollectionView.dataSource = self;
    self.activityCollectionView.backgroundColor = [UIColor whiteColor];
        
    [self.activityCollectionView registerClass:[EHActivityCell class] forCellWithReuseIdentifier:[EHActivityCell description]];
    
    [self addSubview:self.activityView];
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
    }];
        
    [self.activityView addSubview: self.activityCollectionView];
    [self.activityCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.activityView);
    }];
    
#pragma mark - 活动管理
    UIView *manageView = [[UIView alloc] init];
    UIImageView *manageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_management"]];
    UILabel *manageLabel = [self createLabel:@"活动管理"];
    [manageView addSubview:manageIcon];
    [manageView addSubview:manageLabel];
    
    [manageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(manageView);
        make.centerY.equalTo(manageView);
    }];
    [manageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(manageIcon.mas_right);
        make.top.right.bottom.equalTo(manageView);
    }];
    UITapGestureRecognizer *manageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toManage)];
    [manageView addGestureRecognizer:manageTap];
    
#pragma mark - 发布活动
    UIView *releaseView = [[UIView alloc] init];
    UIImageView *releaseIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_release"]];
    UILabel *releaseLabel = [self createLabel:@"我要发布"];
    [releaseView addSubview:releaseIcon];
    [releaseView addSubview:releaseLabel];
    
    [releaseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(releaseView);
        make.centerY.equalTo(releaseView);
    }];
    [releaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(releaseIcon.mas_right);
        make.top.right.bottom.equalTo(releaseView);
    }];
    UITapGestureRecognizer *releaseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toRelease)];
    [releaseView addGestureRecognizer:releaseTap];
    
    [_whiteView addSubview:manageView];
    [_whiteView addSubview:releaseView];
    [releaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_whiteView).offset(-12);
        make.centerY.equalTo(_whiteView);
    }];
    [manageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(releaseView.mas_left).offset(-8);
        make.centerY.equalTo(_whiteView);
    }];
    
    
}

- (void)setShowCity:(BOOL)showCity {
    _showCity = showCity;
    self.cityTableView.hidden = !showCity;
}

- (void)setShowDistrict:(BOOL)showDistrict {
    _showDistrict = showDistrict;
    self.districtTableView.hidden = !showDistrict;
}

#pragma mark - TableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.provinceTableView) {
        return self.provinces.count;
    } else if (tableView == self.cityTableView) {
        return self.currentCities.count;
    } else {
        return self.currentDistricts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHAreaCell *cell = [[EHAreaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (tableView == self.provinceTableView) {
        cell.areaLabel.text = self.provinces[indexPath.row];
    } else if (tableView == self.cityTableView) {
        cell.areaLabel.text = self.currentCities[indexPath.row];
    } else {
        cell.areaLabel.text = self.currentDistricts[indexPath.row];
    }

    return cell;
}
#pragma mark - 选择地区

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.provinceTableView) {
        // 如果选择了“全部”
        if ([self.provinces[indexPath.row] isEqualToString:@"全部"]) {
            self.selectedProvince = @"全国";
            self.selectedCity = nil;
            self.selectedDistrict = nil;
            self.showCity = NO;
            self.showDistrict = NO;
            // 更新按钮显示的文本
            [self updateLocationButtonText];
        } else {
            self.selectedProvince = self.provinces[indexPath.row];
            self.currentCities = self.cities[self.selectedProvince];
            self.selectedCity = self.currentCities.firstObject;
            self.selectedDistrict = nil;
            self.showCity = YES;
            self.showDistrict = NO;
        }
        // 更新城市表格
        [self.cityTableView reloadData];
        [self.districtTableView reloadData];

    } else if (tableView == self.cityTableView) {
        // 如果选择了“全部”
        if ([self.currentCities[indexPath.row] isEqualToString:@"全部"]) {
            self.selectedCity = nil;
            self.selectedDistrict = nil;
            self.showDistrict = NO;
            // 更新按钮显示的文本
            [self updateLocationButtonText];
        } else {
            self.selectedCity = self.currentCities[indexPath.row];
            self.currentDistricts = self.districts[self.selectedCity];
            self.selectedDistrict = self.currentDistricts.firstObject;
            self.selectedDistrict = nil;
            self.showDistrict = YES;
        }
        // 更新区表格
        [self.districtTableView reloadData];

    } else if (tableView == self.districtTableView) {
        // 如果选择了“全部”
        if ([self.currentDistricts[indexPath.row] isEqualToString:@"全部"]) {
            self.selectedDistrict = nil;
        } else {
            self.selectedDistrict = self.currentDistricts[indexPath.row];
        }

        // 更新按钮显示的文本
        [self updateLocationButtonText];
    }
}

- (void)updateLocationButtonText {
    NSString *locationText = @"";
    
    // 判断是否选择了“全国”
    if ([self.selectedProvince isEqualToString:@"全国"]) {
        locationText = @"全国";
    } else {
        locationText = self.selectedProvince;
        
        // 如果选择了省份，显示城市
        if (self.showCity && self.selectedCity) {
            locationText = [NSString stringWithFormat:@"%@", self.selectedCity];
        }
        
        // 如果选择了城市，显示区
        if (self.showDistrict && self.selectedDistrict) {
            locationText = [NSString stringWithFormat:@"%@", self.selectedDistrict];
        }
    }
    
    self.areaLabel.text = locationText;
    [self.delegate didSelectAreaWithProvince:self.selectedProvince city:self.selectedCity district:self.selectedDistrict];
    [self toggleAreaSelection];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.activityTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EHActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[EHActivityCell description] forIndexPath:indexPath];
    
    // 创建 UIButton 并设置
    cell.view.backgroundColor = (indexPath == self.selectedIndexPath) ? EHMainColor : [UIColor colorWithHexString:@"#F6F6F6"];  // 设置选中按钮的背景颜色

    cell.label.text = self.activityTitles[indexPath.row];
    cell.label.textColor = (indexPath == self.selectedIndexPath) ? [UIColor whiteColor] : [UIColor colorWithHexString:@"#333333"];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

// 选中按钮时更新状态
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.selectedIndexPath) {
        self.selectedIndexPath = indexPath;
        [collectionView reloadData];
    }
    if (self.selectedIndexPath != indexPath) {
        self.selectedIndexPath = indexPath;
        [collectionView reloadData];  // 重新加载数据，刷新按钮状态
    }
    self.activityLabel.text = self.activityTitles[indexPath.row];
    [self.delegate didSelectActivity:self.activityTitles[indexPath.row]];
    // 延迟执行代码
    __weak typeof(self) weakSelf = self;
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)); // 延迟2秒
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        // 这里写延时执行的代码
        [weakSelf toggleActivitySelection];
    });
    
}

#pragma mark - 地区展开/收起
- (void)toggleAreaSelection {
    self.isAreaExpanded = !self.isAreaExpanded;
    if (self.isActivityExpend) {
        self.isActivityExpend = !self.isActivityExpend;
        [UIView animateWithDuration:0.3 animations:^{
            [self.activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.whiteView.mas_bottom);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(1);
            }];
            self.activityView.alpha = 0;
            self.activityLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            self.activityIcon.tintColor = [UIColor colorWithHexString:@"#333333"];
            self.activityIcon.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0);
            [self layoutIfNeeded];
        }];
        
        [self.delegate didCloseSelection];
    }
    if (self.isAreaExpanded) {
        //展开
        [self.delegate didExpandSelection];
        [UIView animateWithDuration:0.3 animations:^{
            self.containerView.alpha = 1;
            [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.whiteView.mas_bottom);
                make.left.right.equalTo(self);
                make.bottom.equalTo(self.mas_bottom).offset(-150);
            }];
            self.areaIcon.tintColor = EHMainColor;
            self.areaLabel.textColor = EHMainColor;
            self.areaIcon.layer.transform = CATransform3DMakeRotation(-M_PI, 1, 0, 0);
            [self layoutIfNeeded];
        }];
    }else {
        //收起
        [UIView animateWithDuration:0.3 animations:^{
            [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.whiteView.mas_bottom);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(1);
            }];
            self.containerView.alpha = 0;
            self.areaLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            self.areaIcon.tintColor = [UIColor colorWithHexString:@"#333333"];
            self.areaIcon.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0);
            [self layoutIfNeeded];
        }];
        [self.delegate didCloseSelection];
        
        
    }
}
#pragma mark - 活动展开/收起
- (void) toggleActivitySelection {
    self.isActivityExpend = !self.isActivityExpend;
    if (self.isAreaExpanded) {
        self.isAreaExpanded = !self.isAreaExpanded;
        [UIView animateWithDuration:0.3 animations:^{
            [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.whiteView.mas_bottom);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(1);
            }];
            self.containerView.alpha = 0;
            self.areaLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            self.areaIcon.tintColor = [UIColor colorWithHexString:@"#333333"];
            self.areaIcon.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0);
            [self layoutIfNeeded];
        }];
        [self.delegate didCloseSelection];
    }
    if (self.isActivityExpend) {
        [self.delegate didExpandSelection];
        [UIView animateWithDuration:0.3 animations:^{
            self.activityView.alpha = 1;
            [self.activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.whiteView.mas_bottom);
                make.left.right.equalTo(self);
                make.bottom.equalTo(self.mas_bottom).offset(-250);
            }];
            self.activityIcon.tintColor = EHMainColor;
            self.activityLabel.textColor = EHMainColor;
            self.activityIcon.layer.transform = CATransform3DMakeRotation(-M_PI, 1, 0, 0);
            [self layoutIfNeeded];
        }];
        
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.whiteView.mas_bottom);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(1);
            }];
            self.activityView.alpha = 0;
            self.activityLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            self.activityIcon.tintColor = [UIColor colorWithHexString:@"#333333"];
            self.activityIcon.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0);
            [self layoutIfNeeded];
        }];
        
        [self.delegate didCloseSelection];
    }
 }

- (void) toManage {
    [self.delegate clickManageView];
}

- (void) toRelease {
    [self.delegate clickReleaseView];
}

- (UITableView *)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[EHAreaCell self] forCellReuseIdentifier:[EHAreaCell description]];
    return tableView;
}

- (UILabel *)createLabel:(NSString *) text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    return label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isAreaExpanded) {
        [self.containerView setCornerWithRadius:10.0 corners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)];
    }
    if (self.isActivityExpend) {
        [self.activityView setCornerWithRadius:10.0 corners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)];
    }
}

@end
