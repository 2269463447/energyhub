//
//  EHEliteJoinViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/9/1.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHEliteJoinViewController.h"
#import "EHEliteJoinCell.h"
#import "UIImage+Color.h"
#import "EHBusinessServer.h"
#import "UIViewController+Share.h"

#define ItemBackColor RGBColor(255, 133, 0)

@interface EHEliteJoinViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *skillsView;
@property (weak, nonatomic) IBOutlet UIView *modeView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *dataArray;

/** 选中的cell*/
@property (nonatomic, strong) EHEliteJoinCell * currentCell;

/** 选中的行*/
@property (nonatomic, assign) NSInteger selectedRow;
@property (weak, nonatomic) IBOutlet UIButton *hireButton;
@property (weak, nonatomic) IBOutlet UIButton *partnerButton;
@property (weak, nonatomic) IBOutlet UIButton *shareholdersButton;
@property (nonatomic, strong) EHBusinessServer *joinServer;
@end

@implementation EHEliteJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self otherConfig];
    [self facilitateShare];
}

- (void)otherConfig {
    self.view.backgroundColor = kBackgroundColor;
    self.phoneTextField.layer.borderColor = EHLineColor.CGColor;
    self.phoneTextField.layer.borderWidth = 1;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"EHEliteJoinCell" bundle:nil] forCellWithReuseIdentifier:@"EHEliteJoinCell"];
    
    self.hireButton.layer.cornerRadius = 3;
    self.hireButton.layer.masksToBounds = YES;
    self.hireButton.layer.borderWidth = 1;
    self.hireButton.layer.borderColor = ItemBackColor.CGColor;
    [self.hireButton setBackgroundImage:[UIImage createImageWithColor:ItemBackColor] forState:UIControlStateSelected];
    [self.hireButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.hireButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.hireButton setTitleColor:ItemBackColor forState:UIControlStateNormal];


    self.partnerButton.layer.cornerRadius = 3;
    self.partnerButton.layer.masksToBounds = YES;
    self.partnerButton.layer.borderWidth = 1;
    self.partnerButton.layer.borderColor = ItemBackColor.CGColor;
    [self.partnerButton setBackgroundImage:[UIImage createImageWithColor:ItemBackColor] forState:UIControlStateSelected];
    [self.partnerButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.partnerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.partnerButton setTitleColor:ItemBackColor forState:UIControlStateNormal];


    self.shareholdersButton.layer.cornerRadius = 3;
    self.shareholdersButton.layer.masksToBounds = YES;
    self.shareholdersButton.layer.borderWidth = 1;
    self.shareholdersButton.layer.borderColor = ItemBackColor.CGColor;
    [self.shareholdersButton setBackgroundImage:[UIImage createImageWithColor:ItemBackColor] forState:UIControlStateSelected];
    [self.shareholdersButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.shareholdersButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.shareholdersButton setTitleColor:ItemBackColor forState:UIControlStateNormal];
}

#pragma mark -- Getter

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"UI设计", @"数据库", @"算法", @"JAVA", @"课程老师", @"架构", @"安全", @"投资人", @"产品策划", @"运营", @"交互", @"SEO", @"市场推广", @"程序员", @"融资", @"录像"];
    }
    return _dataArray;
}

- (EHBusinessServer *)joinServer {
    if (!_joinServer) {
        _joinServer = [[EHBusinessServer alloc] init];
    }
    return _joinServer;
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.phoneTextField.layer.borderColor = EHMainColor.CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.phoneTextField.layer.borderColor = EHLineColor.CGColor;
}

#pragma mark -- UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EHEliteJoinCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EHEliteJoinCell" forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentCell) {
        self.currentCell.titleLabel.backgroundColor = kBackgroundColor;
        self.currentCell.titleLabel.textColor = ItemBackColor;
        self.currentCell.titleLabel.layer.borderColor = EHLineColor.CGColor;
    }else {
        NSArray *cells = [collectionView visibleCells];
        for (EHEliteJoinCell *cell in cells) {
            [cell updateStatus];
        }
    }
    EHEliteJoinCell * cell = (EHEliteJoinCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLabel.backgroundColor = ItemBackColor;
    cell.titleLabel.textColor = [UIColor whiteColor];
    cell.titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.currentCell = cell;
    self.selectedRow = indexPath.row;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 35)/4, 40);
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

#pragma mark -- Action

- (IBAction)commitAction:(id)sender {
    
    if (!self.currentCell) {
        [MBProgressHUD showError:@"请选择技能" toView:self.view];
        return;
    }
    
    if (!self.hireButton.selected && !self.partnerButton.selected && !self.shareholdersButton.selected) {
        [MBProgressHUD showError:@"请选择加入方式" toView:self.view];
        return;
    }
    
    if (self.phoneTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写手机号" toView:self.view];
        return;
    }
    
    if (![Utils validateMobile:self.phoneTextField.text]) {
        [MBProgressHUD showError:@"请填写正确手机号" toView:self.view];
        return;
    }
    
    [MBProgressHUD showLoading:@"" toView:self.view];
    NSString *joinType = @"";
    NSArray *btnArray = @[self.hireButton, self.partnerButton, self.shareholdersButton];
    for (int i = 0; i < btnArray.count; i++) {
        UIButton *button = btnArray[i];
        if (button.selected) {
            joinType = button.currentTitle;
        }
    }
    NSString *joinContent = self.dataArray[self.selectedRow];
    NSDictionary *param = @{@"joinContent":joinContent,
                            @"joinType":joinType,
                            @"contact":self.phoneTextField.text};
    
    DefineWeakSelf
    [self.joinServer eliteJoinDataWithParam:param successBlock:^(id obj) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showSuccess:@"提交成功，请静候佳音" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });

    } errorBlock:^(EHError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:error.msg toView:self.view];
    }];
}

- (IBAction)hireButtonAction:(UIButton *)sender {
    sender.selected = YES;
//    [self setBorderColor:ItemBackColor forView:self.partnerButton];
//    [self setBorderColor:ItemBackColor forView:self.shareholdersButton];
//    [self setBorderColor:[UIColor whiteColor] forView:sender];
    self.partnerButton.selected = NO;
    self.shareholdersButton.selected = NO;
}

- (IBAction)partnerButtonAction:(UIButton *)sender {
    sender.selected = YES;
//    [self setBorderColor:ItemBackColor forView:self.hireButton];
//    [self setBorderColor:ItemBackColor forView:self.shareholdersButton];
//    [self setBorderColor:[UIColor whiteColor] forView:sender];
    self.hireButton.selected = NO;
    self.shareholdersButton.selected = NO;
}

- (IBAction)shareholdersButtonAction:(UIButton *)sender {
    sender.selected = YES;
//    [self setBorderColor:ItemBackColor forView:self.hireButton];
//    [self setBorderColor:ItemBackColor forView:self.partnerButton];
//    [self setBorderColor:[UIColor whiteColor] forView:sender];
    self.partnerButton.selected = NO;
    self.hireButton.selected = NO;
}

- (void)setBorderColor:(UIColor *)color forView:(UIView *)view {
    view.layer.borderColor = color.CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
