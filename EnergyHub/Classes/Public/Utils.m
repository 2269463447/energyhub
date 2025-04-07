//
//  Utils.m
//  EnergyHub
//
//  Created by cpf on 2017/8/19.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "Utils.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AFNetworkReachabilityManager.h>

@implementation Utils


+ (BOOL)isReachable {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    return [manager isReachable];
}

+ (CGRect)getRectwithString:(NSString *)string withFont:(CGFloat)font withWidth:(CGFloat)width
{
    CGRect rect=[string boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect;
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex =@"^1[3|4|5|6|7|8|9][0-9]{1}[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (void)readImageDataFromPhotoLibraryWithURL:(NSURL *)imageUrl success:(ALAssetLibraryResultBlock)resultBlock {
    
    if (!imageUrl) {
        !resultBlock ? : resultBlock(nil, nil);
        return;
    }
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    
    void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *) = ^(ALAsset *asset) {
        
        if (asset != nil) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            unsigned long assetSize = (unsigned long)rep.size;
            Byte *imageBuffer = (Byte*)malloc(assetSize);
            NSUInteger bufferSize = [rep getBytes:imageBuffer fromOffset:0.0 length:assetSize error:nil];
            NSData *imageData = [NSData dataWithBytesNoCopy:imageBuffer length:bufferSize freeWhenDone:YES];
            //NSLog(@"read a asset size: %@ KB succes for url: %@, filename= %@", @(imageData.length / 1024), imageUrl, rep.filename);
            !resultBlock ? : resultBlock(imageData, rep.filename);
            //free(imageBuffer);
        }else {
            NSLog(@"read a emtpy asset for url: %@", imageUrl);
        }
    };
    
    [assetLibrary assetForURL:imageUrl
                  resultBlock:ALAssetsLibraryAssetForURLResultBlock
                 failureBlock:^(NSError *error){
                     !resultBlock ? : resultBlock(nil, nil);
                     NSLog(@"read asset error: %@ for url: %@", error, imageUrl);
                 }];
    
}

+ (NSString *)imageTypeForData:(NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    NSString *imageType = nil;
    switch (c) {
            
        case 0xFF:
            imageType = @"image/jpeg";
            break;
            
        case 0x89:
            imageType =  @"image/png";
            break;
            
        case 0x47:
            imageType =  @"image/gif";
            break;
            
        case 0x49:
        case 0x4D:
            imageType =  @"image/tiff";
            break;
            
        default:
            imageType = @"image/jpeg";
            break;
    }
    
    return imageType;
}

///////// Info.plist ///////////

+ (NSString *)bundleId
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDict objectForKey:@"CFBundleIdentifier"];
    return version;
}

+ (NSString *)appVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+ (NSString *)buildVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDict objectForKey:@"CFBundleVersion"];
    return version;
}

+ (NSString *)randomFileName {
    
    NSString *source = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = @"YYYYMMDDHHmmss";
    NSString *dateString = [formater stringFromDate:now];
    
    NSMutableString *randomString = [[NSMutableString alloc]initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        [randomString appendString:[source substringWithRange:NSMakeRange(arc4random() % source.length, 1)]];
    }
    return [NSString stringWithFormat:@"%@%@", dateString, randomString];
}


@end
