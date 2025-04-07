//
//  JEPhotographyHelper.m
//  JiaeD2C
//
//  Created by fanzhou on 16/4/21.
//  Copyright © 2016年 www.jiae.com. All rights reserved.
//

#import "JEPhotographyHelper.h"
#import "PhotoViewController.h"

@interface JEPhotographyHelper()
<
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    PhotoViewControllerDelegate
>

@property (nonatomic, copy) JETakeMediaCompletionBlock completionBlock;

@property (nonatomic, strong) NSDictionary *info;

@property (nonatomic, assign) BOOL cropHeader;

@end

@implementation JEPhotographyHelper

+ (instancetype)sharedHelper {
    
    static JEPhotographyHelper *helper;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        helper = [[JEPhotographyHelper alloc] init];
    });
    return helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)showAvatarPickerIn:(UIViewController *)controller sourceType:(UIImagePickerControllerSourceType)sourceType completionHandler:(JETakeMediaCompletionBlock)completionHandler {
    JEPhotographyHelper *helper = [self sharedHelper];
    helper.cropHeader = YES;
    [self showImagePickerIn:controller sourceType:sourceType completionHandler:completionHandler];
}

+ (void)showImagePickerIn:(UIViewController *)controller sourceType:(UIImagePickerControllerSourceType)sourceType completionHandler:(JETakeMediaCompletionBlock)completionHandler {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        !completionHandler ?: completionHandler(nil, nil);
        return;
    }
    JEPhotographyHelper *helper = [self sharedHelper];
    helper.completionBlock = [completionHandler copy];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = helper;
    imagePickerController.sourceType = sourceType;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    [controller presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)dismissPickerViewController:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        _completionBlock = nil;
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.info = info;
    UIImage *uploadImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    photoVC.oldImage = uploadImage;
    if (self.cropHeader) {
        photoVC.mode = PhotoMaskViewModeCircle;
        photoVC.cropHeight = kScreenWidth - 30;
    }else {
        photoVC.mode = PhotoMaskViewModeNone;
    }
    photoVC.delegate = self;
    [picker pushViewController:photoVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissPickerViewController:picker];
}

#pragma mark - photoViewControllerDelegate

- (void)imageCropper:(PhotoViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    if (self.completionBlock) {
        self.completionBlock(editedImage, self.info);
    }
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(PhotoViewController *)cropperViewController
{
    [cropperViewController.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    _completionBlock = nil;
}

@end
