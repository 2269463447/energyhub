//
//  EHFeedbackViewController.m
//  EnergyHub
//
//  Created by fanzhou on 2017/9/10.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHFeedbackViewController.h"
#import <Photos/Photos.h>
#import "EHUploadCell.h"
#import "EHHomeService.h"
#import "FSTextView.h"
#import "JEPhotographyHelper.h"

const NSUInteger kImageCountMax = 2;

@interface EHFeedbackViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FSTextView *textView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableDictionary *imageDict;
@property (nonatomic, strong) EHHomeService *service;

@end

@implementation EHFeedbackViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - Private Methods

- (void) setupUI {
    self.title = @"用户反馈";
    self.view.backgroundColor = kBackgroundColor;
    // top margin
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    topView.backgroundColor = [UIColor colorNamed:@"FeedbackColor"];
    // textView
    FSTextView *textView = [FSTextView textView];
    textView.backgroundColor = kBackgroundColor;
    textView.frame = CGRectMake(10, topView.bottom, kScreenWidth - 30, 100);
    textView.font = [UIFont systemFontOfSize:14];
    textView.placeholderFont = [UIFont systemFontOfSize:14];
    textView.placeholderColor = [UIColor grayColor];
    textView.placeholder = @"请把你的想法告诉我们";
    self.textView = textView;
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, textView.bottom, kScreenWidth, 44)];
    titleLabel.backgroundColor = [UIColor colorNamed:@"FeedbackColor"];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"      图片 (可选项, 提供问题截图, 最多2张)";
    // upload
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = 60.f;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + 10, kScreenWidth, 80) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = kBackgroundColor;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    RegisterCellToCollection(@"EHUploadCell", self.collectionView)
    // bottom margin
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bottom, kScreenWidth, 10)];
    bottomView.backgroundColor = [UIColor colorNamed:@"FeedbackColor"];
    // submit
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(25, bottomView.bottom + 15, kScreenWidth - 50, 40);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitBtn setBackgroundColor:EHMainColor];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topView];
    [self.view addSubview:textView];
    [self.view addSubview:titleLabel];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:bottomView];
    [self.view addSubview:submitBtn];
}

#pragma mark - Custom Method

- (void)submitBtnClick {
    
    [self.view endEditing:YES];
    // 合法性检验
    if (self.textView.formatText.length == 0) {
        [MBProgressHUD showError:@"请填写反馈信息" toView:self.view];
        return;
    }
    
    DefineWeakSelf
    [self.service feedbackWithComment:self.textView.formatText
                          imageInfo:self.imageDict
                         successBlock:^(NSString *message) {
        if (message == nil) {
            [weakSelf.textView resignFirstResponder];
            [MBProgressHUD showSuccess:@"反馈成功" toView:weakSelf.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            [MBProgressHUD showError:message toView:weakSelf.view];
        }
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

- (void)uploadFeedbackImage {
    // 最多2张
    if (self.listData.count >= kImageCountMax) {
        [MBProgressHUD showError:@"最多上传2张" toView:self.view];
        return;
    }
    DefineWeakSelf
    JETakeMediaCompletionBlock pickerMediaBlock = ^(UIImage *image, NSDictionary *editingInfo) {
        if (image) {
            // 如果是从相册中选取，读取相册中的图片，如果是拍照，直接使用image
            NSURL *imageURL = editingInfo[UIImagePickerControllerPHAsset];
            // 如果是拍照imageUrl为空,此时使用image，默认JPEG格式
            NSString *imageName = [NSString stringWithFormat:@"%@.png", [Utils randomFileName]];
            if (!imageURL) {
                UIImage *originalImage = editingInfo[UIImagePickerControllerOriginalImage];
                [weakSelf.imageDict setObject:UIImagePNGRepresentation(originalImage) forKey:imageName];
                [weakSelf.listData insertObject:imageName atIndex:0];
                [weakSelf.collectionView reloadData];
                return;
            }
            EHLog(@"image :=========%@", editingInfo[UIImagePickerControllerOriginalImage]);
            // 从相册中读取数据
            PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageURL] options:nil];
            PHAsset *asset = result.firstObject;
            PHImageManager *manager = [PHImageManager defaultManager];
            [manager requestImageForAsset:asset targetSize:CGSizeMake(60, 60) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [self.listData insertObject:imageName atIndex:0];
                NSData *imageData = UIImagePNGRepresentation(result);
                if (!imageData) {
                    imageData = UIImageJPEGRepresentation(image, 0.5);
                }
                [self.imageDict setObject:imageData forKey:imageName];
                [self.collectionView reloadData];
            }];
        } else {
            if (!editingInfo)
            return;
        }
    };
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:@"相机拍照" handler:^{
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alertView =
            [UIAlertView bk_alertViewWithTitle:@"提示"
                                       message:@"能量库需要访问您的摄像头。\n请启用相册访问权限-设置/隐私/相机"];
            [alertView bk_addButtonWithTitle:@"提示" handler:nil];
            [alertView show];
            return;
        }
        [JEPhotographyHelper showImagePickerIn:weakSelf sourceType:UIImagePickerControllerSourceTypeCamera completionHandler:pickerMediaBlock];
    }];
    [actionSheet bk_addButtonWithTitle:@"从相册选择" handler:^{
        [JEPhotographyHelper showImagePickerIn:weakSelf sourceType:UIImagePickerControllerSourceTypePhotoLibrary completionHandler:pickerMediaBlock];
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"确定" handler:nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.listData.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EHUploadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(EHUploadCell.class) forIndexPath:indexPath];
    if (indexPath.item < self.listData.count) {
        NSString *imageName = self.listData[indexPath.item];
        cell.imageData = [self.imageDict objectForKey:imageName];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == self.listData.count) {
        [self uploadFeedbackImage];
    }
}

#pragma mark - Getter

- (NSMutableArray *)listData
{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
}

- (NSMutableDictionary *)imageDict {
    
    if (!_imageDict) {
        _imageDict = [NSMutableDictionary dictionary];
    }
    return _imageDict;
}

- (EHHomeService *)service
{
    if (!_service) {
        _service = [[EHHomeService alloc] init];
    }
    return _service;
}

@end
