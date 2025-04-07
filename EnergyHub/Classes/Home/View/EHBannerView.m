//
//  EHBannerView.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHBannerView.h"
#import "EHBannerImageCell.h"
#import "DDPageControl.h"


#define kBannerIsCycle   YES
#define kBannerCycleTime 5.0f

@interface EHBannerView ()
<
    UICollectionViewDataSource,
    UICollectionViewDelegate
>

@property (strong, nonatomic) UICollectionView *collectionView ;
@property (strong, nonatomic) NSTimer *timer ;
@property (strong, nonatomic) DDPageControl *pageControl ;

@property (nonatomic, assign) NSUInteger totalRows ;
@property (nonatomic, assign) NSUInteger defaultRow ;
@property (nonatomic, assign) NSInteger nextItem ;

@end


@implementation EHBannerView

#pragma mark - Public Methods

+ (instancetype) bannerView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBannerHeight)] ;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI] ;
        [self addTimer];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupUI] ;
        [self addTimer];
    }
    
    return self ;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    //[self setupUI] ;
    //[self addTimer];
}

#pragma mark - Life Cycle Methods

- (void) layoutSubviews {
    [super layoutSubviews] ;
    
    self.collectionView.frame = CGRectMake(0, 0, self.width, self.height) ;
    //self.collectionView.frame = CGRectMake(0, 0, self.width, JEAdvertisementHeight) ;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout ;
    flowLayout.itemSize = CGSizeMake(self.width, self.height) ;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    [self.collectionView reloadData] ;
    
    // 默认组
    if (self.adList.count > 1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.defaultRow inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:NO];
    }
    self.pageControl.centerX = self.width * 0.5 ;
    self.pageControl.y = self.height - 35 ;
}

#pragma mark - Private Methods

- (void) setupUI {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 0 ;
    flowLayout.minimumLineSpacing = 0 ;
    UICollectionView *collectionView =
    [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self ;
    collectionView.dataSource = self ;
    collectionView.pagingEnabled = YES ;
    collectionView.showsHorizontalScrollIndicator = NO ;
    collectionView.showsVerticalScrollIndicator = NO ;
    collectionView.scrollsToTop = NO ;
    [collectionView registerClass:[EHBannerImageCell class] forCellWithReuseIdentifier:@"EHBannerImageCell"];
    collectionView.backgroundColor = [UIColor clearColor] ;
    [self addSubview:collectionView];
    self.collectionView = collectionView ;
    
    [self addSubview:self.pageControl] ;
}

- (void) removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void) addTimer {
    [self removeTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kBannerCycleTime
                                                  target:self
                                                selector:@selector(nextAdvertisement)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}

- (void) nextAdvertisement {
    if (self.adList.count > 1) {
        NSIndexPath *visiablePath = [[self.collectionView indexPathsForVisibleItems] firstObject];
        NSUInteger visiableItem = visiablePath.item ;
        if ((visiableItem % self.adList.count) == 0) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.defaultRow inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft
                                                animated:NO];
            visiableItem = self.defaultRow;
        }
        
        BOOL isCycle = kBannerIsCycle ;
        if (visiableItem == self.adList.count - 1 && !isCycle) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionRight
                                                animated:YES];
            return ;
        }
        
        NSUInteger nextItem = visiableItem + 1 ;
        self.nextItem = nextItem ;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        
    }
}

- (void) willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow] ;
    
    if (!newWindow) {
        [self removeTimer] ;
        if (self.nextItem < self.adList.count) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.nextItem inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft
                                                animated:NO];
        }
        
    } else {
        [self addTimer] ;
    }
}

- (void) removeFromSuperview {
    [self removeTimer] ;
    [super removeFromSuperview] ;
}

#pragma mark - Setter and Getter

- (void)setAdList:(NSArray *)adList {
    _adList = adList;
    
    if (adList.count > 0) {
        // 刷新数据
        [self.collectionView reloadData];
        
        // 默认组
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.defaultRow inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:NO];
        
        // 设置显示的个数
        self.pageControl.numberOfPages = adList.count ;
    }
}

- (NSUInteger) totalRows {
    return (kBannerIsCycle && self.adList.count > 1) ? (10000 * self.adList.count) : self.adList.count ;
}

- (NSUInteger) defaultRow {
    return kBannerIsCycle ? (NSUInteger)(self.totalRows * 0.5) : 0 ;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalRows ;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView
                   cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"EHBannerImageCell";
    EHBannerImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.imageUrl = self.adList[indexPath.item % self.adList.count];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *visiblePath = [[collectionView indexPathsForVisibleItems] firstObject] ;
    self.nextItem = visiblePath.item ;
    if (visiblePath != nil) {
        NSInteger index = visiblePath.item % self.adList.count ;
        self.pageControl.currentPage = index ;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self addTimer];
}


#pragma mark - Getter

- (DDPageControl *) pageControl {
    if (!_pageControl) {
        _pageControl = [[DDPageControl alloc] initWithType:DDPageControlTypeOnFullOffEmpty] ;
        _pageControl.userInteractionEnabled = NO ;
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl ;
}


#pragma mark - Memory Methods

- (void)dealloc {
    [self removeTimer];
}

@end
