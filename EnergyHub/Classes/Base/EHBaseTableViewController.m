//
//  EHBaseTableViewController.m
//  Energy
//
//  Created by gaojuyan on 16/4/5.
//  Copyright © 2017年 Energy. All rights reserved.
//

#import "EHBaseTableViewController.h"

@interface EHBaseTableViewController ()

@end

@implementation EHBaseTableViewController

+ (instancetype)instance {
    EHLog(@"====base instance = %@", NSStringFromClass(self));
    //NSAssert(NO, @"subclass must override this method!");
    return [[self alloc]init];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self _baseCommonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self _baseCommonInit];
    }
    return self;
}

- (void)_baseCommonInit
{
    [self commonInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doInViewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self trackPageBegin];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[self trackPageEnd];
}

- (void)setHasMore:(BOOL)hasMore {
    _hasMore = hasMore;
    // more footer view
}

- (void)dealloc
{
    [self.tableView setDataSource:nil];
    [self.tableView setDelegate:nil];
    [self unloadDataModel];
}

@end
