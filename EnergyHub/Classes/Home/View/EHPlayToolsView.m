//
//  EHPlayToolsView.m
//  EnergyHub
//
//  Created by cpf on 2017/8/14.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHPlayToolsView.h"
#import "EHToolsViewCell.h"

const NSInteger kToolsCount = 5;

@interface EHPlayToolsView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray * itemArray;

@end

@implementation EHPlayToolsView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = kBackgroundColor;
    [self addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(0, 1, self.width, self.height);
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 1, kScreenWidth, 1.f)];
    downLine.backgroundColor = EHSeparatorColor;
    [self addSubview:downLine];
    UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.f)];
    upLine.backgroundColor = EHSeparatorColor;
    [self addSubview:upLine];
    
    
}

#pragma mark -- Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.minimumLineSpacing = 0;
        flowlayout.minimumInteritemSpacing = 0;
        CGFloat itemW = kScreenWidth / kToolsCount;
        flowlayout.itemSize = CGSizeMake(itemW, 78);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kBackgroundColor;
        [_collectionView registerNib:[UINib nibWithNibName:@"EHToolsViewCell" bundle:nil] forCellWithReuseIdentifier:@"EHToolsViewCell"];
    }
    return _collectionView;
}

- (NSArray *)itemArray {
    if (!_itemArray) {
        _itemArray = @[@{@"title" : @"目录",
                         @"imgName" : @"icon_menu"},
                       @{@"title" : @"详情",
                         @"imgName" : @"icon_detail"},
                       @{@"title" : @"打赏",
                         @"imgName" : @"icon_tip"},
                       @{@"title" : @"缓存",
                         @"imgName" : @"icon_down"},
                       @{@"title" : @"分享",
                         @"imgName" : @"icon_share"}];
    }
    return _itemArray;
}
//
//- (void)creatButton {
//    
//    NSArray * itemArray = @[@{@"title" : @"目录",
//                             @"imgName" : @"icon_menu"},
//                             @{@"title" : @"详情",
//                               @"imgName" : @"icon_detail"},
//                             @{@"title" : @"打赏",
//                               @"imgName" : @"icon_tip"},
//                             @{@"title" : @"缓存",
//                               @"imgName" : @"icon_down"},
//                             @{@"title" : @"分享",
//                               @"imgName" : @"icon_share"}];
//    CGFloat buttonHeightAndWidth = 45;
//    CGFloat space = (kScreenWidth - buttonHeightAndWidth*5)/6;
//    for (int i = 0; i < itemArray.count; i++) {
//        
//        NSString * title = [itemArray[i] objectForKey:@"title"];
//        NSString * imgName = [itemArray[i] objectForKey:@"imgName"];
//        
//        DirectionButton * button = [DirectionButton buttonWithType:UIButtonTypeCustom];
//        button.layoutDirection = DirectionButtonLayoutVerticalImageUp;
//        button.frame = CGRectMake(i*buttonHeightAndWidth + (i+1)*space, 10, buttonHeightAndWidth, buttonHeightAndWidth);
//        [button setTitle:title forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
////        button.imageEdgeInsets = UIEdgeInsetsMake(0, 7.5, 15, 7.5);
////        button.titleEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
////        button.contentEdgeInsets = UIEdgeInsetsMake(35, 0, 0, 0);
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = 100 + i;
//        [self addSubview:button];
//    }
//}
//
//- (void)buttonAction:(UIButton *)sender {
//}


#pragma mark -- collectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EHToolsViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EHToolsViewCell" forIndexPath:indexPath];
    cell.data = self.itemArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(didSelectView:index:)]) {
        [_delegate didSelectView:self index:indexPath.row];
    }
}

@end
