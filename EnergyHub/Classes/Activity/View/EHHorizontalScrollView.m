//
//  EHHorizontalScrollView.m
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/3/22.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

// EHHorizontalScrollView.m
#import "EHHorizontalScrollView.h"

@interface EHHorizontalScrollView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *horizontalCollectionView;
@property (nonatomic, strong) UIView *sliderView;  // 滑动条


@end

@implementation EHHorizontalScrollView

- (instancetype)initWithFrame:(CGRect)frame activities:(NSArray<NSString *> *)activities {
    self = [super initWithFrame:frame];
    if (self) {
        self.activities = activities;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 初始化横向滚动的UICollectionView
    self.selectIndex = 0;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.itemSize = CGSizeMake(78, 44);

    self.horizontalCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.horizontalCollectionView.showsHorizontalScrollIndicator = NO;
    self.horizontalCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.horizontalCollectionView.backgroundColor = [UIColor clearColor];
    self.horizontalCollectionView.delegate = self;
    self.horizontalCollectionView.dataSource = self;
    
    [self.horizontalCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ActivityCell"];
    
    [self addSubview:self.horizontalCollectionView];
    
    // 初始化底部滑动条
    self.sliderView = [[UIView alloc] init];
    self.sliderView.backgroundColor = EHMainColor;
    self.sliderView.translatesAutoresizingMaskIntoConstraints = NO;
    self.sliderView.layer.cornerRadius = 2;
    self.sliderView.frame = CGRectMake(11, 40, 56, 4);
    
    // 将sliderView添加为horizontalCollectionView的子视图
    [self.horizontalCollectionView addSubview:self.sliderView];
    
    // 设置UICollectionView和滑动条的约束
    [NSLayoutConstraint activateConstraints:@[
        [self.horizontalCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.horizontalCollectionView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
        [self.horizontalCollectionView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
        [self.horizontalCollectionView.heightAnchor constraintEqualToConstant:44],
    ]];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.activities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCell" forIndexPath:indexPath];
    
    // 获取 cell 中的 label
        UILabel *label = [cell.contentView viewWithTag:100]; // 使用 tag 来查找已有的 label
        if (!label) {
            // 如果没有找到 label，说明是第一次创建该 cell，创建并添加 label
            label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
            label.tag = 100;  // 为 label 设置一个唯一的 tag
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
        }
        
        label.text = self.activities[indexPath.row];
        
        // 根据是否是选中的项，修改字体
        if (indexPath.row == _selectIndex) {
            label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        } else {
            label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        }
        
        return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 点击时更新滑动条位置
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.selectIndex = indexPath.row;
    NSLog(@"%ld",(long)self.selectIndex);
    
    // 更新滑动条位置
    CGFloat cellWidth = [collectionView cellForItemAtIndexPath:indexPath].frame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        self.sliderView.frame = CGRectMake(indexPath.row * (cellWidth+10) + 11, self.sliderView.frame.origin.y, 56, 4);
    }];
    
    // 更新选中的cell字体为Bold 16，其它cell字体为Regular 14
    [collectionView reloadData];
    
    // 回调选中的活动
    if (self.activitySelected) {
        self.activitySelected(self.activities[indexPath.row]);
    }
}


@end
