//
//  EHPayManagner.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/4.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHPayManagner.h"
//#import <AlipaySDK/AlipaySDK.h>
//#import "WXApi.h"
#import "EHError.h"

typedef NS_ENUM(NSInteger, AliPayResultCode)
{
    AliPayResultCodeSuccess      = 9000, // 订单支付成功
    AliPayResultCodePending      = 8000, // 正在处理中
    AliPayResultCodeFail         = 4000, // 订单支付失败
    AliPayResultCodeCancel       = 6001, // 用户中途取消
    AliPayResultCodeNetworkError = 6002, // 网络连接出错
};


@interface EHPayManagner ()<WXApiDelegate>

@property (nonatomic, assign) PayMethod payMethod;
@property (nonatomic, copy) PayCompletionBlock completionBlock;

@end

@implementation EHPayManagner

+ (instancetype)sharedManager {
    static EHPayManagner *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EHPayManagner alloc] init];
    });
    return sharedInstance;
}

#pragma mark - OpenURL

- (BOOL)handleOpenURL:(NSURL *)anURL {
    /*
    if (_payMethod == PayMethodWeixin){
        // 微信支付
        return [WXApi handleOpenURL:anURL delegate:self];
    }else if (_payMethod == PayMethodAlipay){
        [[AlipaySDK defaultService] processOrderWithPaymentResult:anURL standbyCallback:^(NSDictionary *resultDic) {
            EHLog(@"alipay standbyCallback result: %@", resultDic);
            NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
            NSString *memo = [resultDic objectForKey:@"memo"];
            // 支付成功
            if (resultStatus == AliPayResultCodeSuccess) {
                !self.completionBlock ?: self.completionBlock(YES, @"订单支付成功");
                return ;
            }
            // 支付失败
            if (memo.length <= 0) {
                memo = @"支付失败";
            }
            if (resultStatus != AliPayResultCodeSuccess) {
                !self.completionBlock ?: self.completionBlock(NO, memo);
            }
        }];
        return YES;
    }*/
    return NO;
}

- (void)processErrorBlock {
//    if (_errorBlock) {
//        JEError *error = [JEError errorWithType:JEOtherError code:JEOtherError message:@"获取信息失败"];
//        _errorBlock(error);
//        _errorBlock = nil;
//    }
}

#pragma mark - WXApiDelegate methods

- (void) onResp:(BaseResp*)resp {
    BOOL result = NO;
    NSString *errorMessage = nil;
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
        if (resp.errCode == WXSuccess) {
            result = YES;
        }else if(resp.errCode == WXErrCodeUserCancel){
            errorMessage = @"取消分享";
        }else {
            errorMessage = resp.errStr;
        }
        
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                /*
                SendAuthResp *response = (SendAuthResp*)resp;
                // 调用接口 获取服务端接口
                [self weixinAccessTokenWithCode:response.code];
                 */
            }
                break;
                
            case WXErrCodeCommon:
                
                errorMessage = @"登录失败";
                break;
                
            case WXErrCodeUserCancel:
                
                errorMessage = @"您已取消";
                break;
                
            case WXErrCodeAuthDeny:
                errorMessage = @"授权失败";
                break;
                
            case WXErrCodeUnsupport:
                errorMessage = @"微信不支持";
                break;
                
            default:
                errorMessage = resp.errStr;
                break;
        }
        if (errorMessage) {
            !_completionBlock ?: _completionBlock(NO, errorMessage);
            return;
        }
        
    } else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
                result = YES;
                errorMessage = @"支付成功";
                break;
                
            default:
                if (resp.errStr) {
                    errorMessage = resp.errStr;
                }else {
                    errorMessage = @"支付失败";
                }
                break;
        }
    }
    
    !self.completionBlock ?: self.completionBlock(result, errorMessage);
}

#pragma mark - pay

- (void)payWithPayMethod:(PayMethod)method
               orderInfo:(id)orderInfo
         completionBlock:(PayCompletionBlock)completionBlock {
    
    self.payMethod = method;
    self.completionBlock = completionBlock;
    
    if (method == PayMethodAlipay) {
        [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:kAlipaySchema callback:^(NSDictionary *resultDic) {
            EHLog(@"alipay callback result : %@", resultDic);
            NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
            NSString *memo = [resultDic objectForKey:@"memo"];
            
            // 支付成功
            if (resultStatus == AliPayResultCodeSuccess) {
                self.completionBlock(YES, @"订单支付成功");
                return ;
            }
            // 支付失败
            if (memo.length <= 0) {
                memo = @"支付失败";
            }
            !self.completionBlock ?: self.completionBlock(NO, memo);
            return;
        }];
    }else if (method == PayMethodWeixin) {
        //调起微信支付
        PayReq *req = [[PayReq alloc] init];
        req.partnerId = orderInfo[@"partnerid"];
        req.prepayId  = orderInfo[@"prepayid"];
        req.nonceStr  = orderInfo[@"noncestr"];
        req.timeStamp = [orderInfo[@"timestamp"] intValue];
        req.package = orderInfo[@"packageValue"];
        req.sign = orderInfo[@"sign"];
        [WXApi sendReq:req];
    }
}

@end
