//
//  JEPhotographyHelper.h
//  JiaeD2C
//
//  Created by fanzhou on 16/4/21.
//  Copyright © 2016年 www.jiae.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JEPhotographyHelper : NSObject

typedef void(^JETakeMediaCompletionBlock)(UIImage *image, NSDictionary *editingInfo);

// 普通图片上传
+ (void)showImagePickerIn:(UIViewController *)controller
               sourceType:(UIImagePickerControllerSourceType)sourceType
        completionHandler:(JETakeMediaCompletionBlock)completionHandler;

// 专门用来上传头像
+ (void)showAvatarPickerIn:(UIViewController *)controller
               sourceType:(UIImagePickerControllerSourceType)sourceType
        completionHandler:(JETakeMediaCompletionBlock)completionHandler;

@end
