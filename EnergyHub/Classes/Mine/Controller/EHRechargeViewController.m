//
//  EHRechargeViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/11/15.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHRechargeViewController.h"
#import "EHRechargeCell.h"
#import "EHChargeTipsCell.h"
#import "UIImage+Color.h"
#import "EHRechargeRecordViewController.h"
#import "EHIAPHelper.h"
#import "EHMineService.h"

@interface EHRechargeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIView *selectMoneyView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) EHRechargeCell *currentCell;
/** 选中的行*/
@property (nonatomic, assign) NSInteger selectedRow;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

// Indicate that there are restored products
@property BOOL restoreWasCalled;
// Indicate whether a download is in progress
@property (nonatomic)BOOL hasDownloadContent;

@property (nonatomic, strong) EHMineService *service;

@end

@implementation EHRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLabelValue];
    [self configCollection];
    [self configButton];
    [self configIAP];
    [self adaptiveNavigation];
}

- (void)updateLabelValue {
    self.nameLabel.text = [@"昵称：" stringByAppendingString:[EHUserInfo sharedUserInfo].nickName];
    self.phoneLabel.text = [@"会员账号：" stringByAppendingString:[EHUserInfo sharedUserInfo].userName];
    
    if([EHUserInfo sharedUserInfo].email.length > 0 ) {
        self.emailLabel.text = [@"邮箱号：" stringByAppendingString:[EHUserInfo sharedUserInfo].email];
    }else{
        self.emailLabel.text = @"邮箱号：" ;
    }
}

- (void)configCollection {
    RegisterCellToCollection(@"EHRechargeCell", self.collectionView)
    RegisterCellToCollection(@"EHChargeTipsCell", self.collectionView)
}

- (void)configButton {
    [self.alipayBtn setBackgroundImage:[UIImage createImageWithColor:EHMainColor] forState:UIControlStateSelected];
    [self.wechatBtn setBackgroundImage:[UIImage createImageWithColor:EHMainColor] forState:UIControlStateSelected];
}

- (void)configIAP {
    self.hasDownloadContent = NO;
    self.restoreWasCalled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleProductRequestNotification:)
                                                 name:IAPProductRequestNotification
                                               object:[StoreManager sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePurchasesNotification:)
                                                 name:IAPPurchaseNotification
                                               object:[StoreObserver sharedInstance]];
    // 改成单个产品
    //[self fetchProductInformation];
}

- (void)adaptiveNavigation {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = kBackgroundColor;
        appearance.backgroundImage = [[UIImage alloc] init];
        appearance.shadowColor = nil;
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }
}

#pragma mark Fetch product information

// Retrieve product information from the App Store
-(void)fetchProductInformation
{
    // Query the App Store for product information if the user is is allowed to make purchases.
    // Display an alert, otherwise.
    if([SKPaymentQueue canMakePayments])
    {
        // Load the product identifiers fron ProductIds.plist
        NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"ProductIds" withExtension:@"plist"];
        NSArray *productIds = [NSArray arrayWithContentsOfURL:plistURL];
        //NSArray *productIds = @[@"com.siyu.energy.100010"];
        [[StoreManager sharedInstance] fetchProductInformationForIds:productIds];
    }
    else
    {
        // Warn the user that they are not allowed to make purchases.
        [self alertWithTitle:@"提示" message:@"此设备不支持购买"];
    }
}

#pragma mark Handle product request notification

// Update the UI according to the product request notification result
-(void)handleProductRequestNotification:(NSNotification *)notification
{
    StoreManager *productRequestNotification = (StoreManager*)notification.object;
    IAPProductRequestStatus result = (IAPProductRequestStatus)productRequestNotification.status;
    
    if (result == IAPProductRequestResponse)
    {
        // SKProducts is available, remove hud
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        EHLog(@"..... start buy ......");
        [self buyProductFromAppstore];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"联系App Store出错" toView:self.view];
    }
}

#pragma mark Handle purchase request notification

// Update the UI according to the purchase request notification result
-(void)handlePurchasesNotification:(NSNotification *)notification
{
    StoreObserver *purchasesNotification = (StoreObserver *)notification.object;
    IAPPurchaseNotificationStatus status = (IAPPurchaseNotificationStatus)purchasesNotification.status;
    
    switch (status)
    {
        case IAPPurchaseFailed:
            //[self alertWithTitle:@"Purchase Status" message:purchasesNotification.message];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"充值失败" toView:self.view];
            break;
        case IAPPurchaseSucceeded:
            EHLog(@".... buy success ....");
            //beginTracer(@"AppStore充值成功");
            [self verifyTransactionResult];
            break;
            // Switch to the iOSPurchasesList view controller when receiving a successful restore notification
        case IAPRestoredSucceeded:
        {
            self.restoreWasCalled = YES;
        }
            break;
        case IAPRestoredFailed:
            [self alertWithTitle:@"Purchase Status" message:purchasesNotification.message];
            break;
            // Notify the user that downloading is about to start when receiving a download started notification
        case IAPDownloadStarted:
        {
            self.hasDownloadContent = YES;
        }
            break;
            // Display a status message showing the download progress
        case IAPDownloadInProgress:
        {
            self.hasDownloadContent = YES;
        }
            break;
            // Downloading is done, remove the status message
        case IAPDownloadSucceeded:
        {
            self.hasDownloadContent = NO;
        }
            break;
            
        default:
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            break;
    }
}

#pragma mark - Display message

-(void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)connectAppstoreWithProductId:(NSString *)productId {
    
    // 先获取产品信息
    if([SKPaymentQueue canMakePayments])
    {
        [MBProgressHUD showLoading:@"正在联系App Store..." toView:self.view];
        NSString *productIdentifier = [NSString stringWithFormat:@"com.siyu.energyhub.%@", productId];
        EHLog(@"product purchased: %@", productIdentifier);
        [[StoreManager sharedInstance] fetchProductInformationForIds:@[productIdentifier]];
    }
    else
    {
        // Warn the user that they are not allowed to make purchases.
        [self alertWithTitle:@"提示" message:@"此设备不支持购买"];
    }
}

- (void)buyProductFromAppstore {
    NSMutableArray *products = [[StoreManager sharedInstance] productRequestResponse];
    IAPProductModel *model = [products firstObject];
    // Only available products can be bought
    if([model.name isEqualToString:@"AVAILABLE PRODUCTS"])
    {
        NSArray *productRequestResponse = model.elements;
        SKProduct *product = (SKProduct *)productRequestResponse[0];
        // Attempt to purchase the tapped product
        [[StoreObserver sharedInstance] buy:product];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"数据错误" toView:self.view];
    }
}

#pragma mark -- UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < _dataArray.count) {
        EHRechargeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EHRechargeCell" forIndexPath:indexPath];
        cell.data = self.dataArray[indexPath.item];
        return cell;
    } else {
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"EHChargeTipsCell" forIndexPath:indexPath];;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (self.currentCell) {
        [self.currentCell changeSelectStatus:NO];
    }else {

    }
    self.currentCell = cell;*/
    if (indexPath.item >= _dataArray.count) {
        return;
    }
    EHRechargeCell *cell = (EHRechargeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell changeSelectStatus:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cell changeSelectStatus:NO];
    });
    self.selectedRow = indexPath.item;
    NSDictionary *dataInfo = self.dataArray[indexPath.item];
    //beginTracer(@"点击充值");
    [self connectAppstoreWithProductId:dataInfo[@"productId"]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < _dataArray.count) {
        return CGSizeMake((kScreenWidth - 35) / 3, 60);
    }
    return CGSizeMake(kScreenWidth - 30, 140);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)alipaySelectAction:(id)sender {
    self.alipayBtn.selected = YES;
    self.wechatBtn.selected = NO;
}

- (IBAction)wechatSelectAction:(id)sender {
    self.wechatBtn.selected = YES;
    self.alipayBtn.selected = NO;
}

- (IBAction)recordeAction:(id)sender {
    EHRechargeRecordViewController *vc = [[EHRechargeRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 改成点击金额直接充值
- (IBAction)buyProduct:(UIButton *)sender {
    
    NSMutableArray *products = [[StoreManager sharedInstance] productRequestResponse];
    IAPProductModel *model = [products firstObject];
    // Only available products can be bought
    if([model.name isEqualToString:@"AVAILABLE PRODUCTS"])
    {
        NSArray *productRequestResponse = model.elements;
        SKProduct *product = (SKProduct *)productRequestResponse[0];
        // Attempt to purchase the tapped product
        [[StoreObserver sharedInstance] buy:product];
    }
}

- (void)verifyTransactionResult{
    
    //验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    
    //从沙盒中获取到购买凭据
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    
    //传输的是BASE64编码的字符串
    /**
     BASE64常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性，BASE64是可以编码和解码的。
     */
    EHLog(@"receipt url: %@", receiptURL);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showLoading:@"正在验证..." toView:self.view];
    //beginTracer(@"开始验证充值结果");
    if (self.selectedRow < 0 || self.selectedRow >= self.dataArray.count) {
        self.selectedRow = 0;
    }
    NSDictionary *dataInfo = self.dataArray[self.selectedRow];
    NSDictionary *param = @{@"receipt-data": [receipt base64EncodedStringWithOptions:0], @"sandbox": @"1", @"money": dataInfo[@"money"], @"uuid": [EHUserInfo sharedUserInfo].uuid};
    
    DefineWeakSelf
    
    [self.service verifyAppstoreReceiptWithParam:param successBlock:^(NSDictionary *responseDictinary) {
        EHLog(@"responseDictionary： %@", responseDictinary);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showSuccess:@"充值成功" toView:weakSelf.view];
        //beginTracer(@"验证充值结果成功");
    } errorBlock:^(EHError *error) {
        EHLog(@"response error： %@", error);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:@"充值失败" toView:weakSelf.view];
        //beginTracer(@"验证充值结果失败");
    }];
    
    // Create a POST request with the receipt data.
    //https://sandbox.itunes.apple.com/verifyReceipt
    
    //EHLog(@"receipt--->%@[end]", param[@"receipt-data"]);
    
    /**
     请求后台接口，服务器处验证是否支付成功，依据返回结果做相应逻辑处理
     与后台协调好，让后台根据你的“sandbox”字段的1，0来区分请求是正式环境还是测试环境
     （当然“sandbox”这个字段也可以替换为你想要的，但是“receipt-data”不能替换，要注意！）
     */
}

#pragma mark - Getter

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@{@"money":@"12",@"UMoney":@"120",@"productId": @"10012"},
                       @{@"money":@"60",@"UMoney":@"720",@"productId": @"20060"},
                       @{@"money":@"108",@"UMoney":@"1400",@"productId": @"10108"},
                       @{@"money":@"208",@"UMoney":@"2760",@"productId": @"10208"},
                       @{@"money":@"618",@"UMoney":@"8250",@"productId": @"10618"},
                       @{@"money":@"1098",@"UMoney":@"14720",@"productId": @"11098"}];
        /*_dataArray = @[@{@"money":@"6",@"UMoney":@"60",@"productId": @"10006"},
                       @{@"money":@"18",@"UMoney":@"180",@"productId": @"10018"},
                       @{@"money":@"30",@"UMoney":@"330",@"productId": @"10030"},
                       @{@"money":@"93",@"UMoney":@"1020",@"productId": @"10093"},
                       @{@"money":@"138",@"UMoney":@"1500",@"productId": @"10138"},
                       @{@"money":@"208",@"UMoney":@"2380",@"productId": @"10208"}];*/

    }
    return _dataArray;
}

- (EHMineService *)service {
    if (!_service) {
        _service = [[EHMineService alloc]init];
    }
    return _service;
}

// 无用 测试用
-(NSMutableArray *)dataSourceForPurchasesUI
{
    NSMutableArray *dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (self.restoreWasCalled && [[StoreObserver sharedInstance] hasRestoredProducts] && [[StoreObserver sharedInstance] hasPurchasedProducts])
    {
        dataSource = [[NSMutableArray alloc] initWithObjects:[[IAPProductModel alloc] initWithName:@"PURCHASED" elements:[StoreObserver sharedInstance].productsPurchased],
                      [[IAPProductModel alloc] initWithName:@"RESTORED" elements:[StoreObserver sharedInstance].productsRestored],nil];
    }
    else if (self.restoreWasCalled && [[StoreObserver sharedInstance] hasRestoredProducts])
    {
        dataSource = [[NSMutableArray alloc] initWithObjects:[[IAPProductModel alloc] initWithName:@"RESTORED" elements:[StoreObserver sharedInstance].productsRestored], nil];
    }
    else if ([[StoreObserver sharedInstance] hasPurchasedProducts])
    {
        dataSource = [[NSMutableArray alloc] initWithObjects:[[IAPProductModel alloc] initWithName:@"PURCHASED" elements:[StoreObserver sharedInstance].productsPurchased], nil];
    }
    
    // Only want to display restored products when the Restore button was tapped and there are restored products
    self.restoreWasCalled = NO;
    return dataSource;
}


@end
