//
//  EHHomeService.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/14.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHHomeService.h"
#import "EHMessageService.h"
#import "EHVideoMenuModel.h"
#import "EHCacheManager.h"

@interface EHHomeService ()

@property (nonatomic, strong) EHRequest *homeBannerRequest;
@property (nonatomic, strong) EHRequest *homeCourseRequest;
@property (nonatomic, strong) EHRequest *courseListRequest;
@property (nonatomic, strong) EHRequest *menuListRequest;
@property (nonatomic, strong) EHRequest *courseDetailRequest;
@property (nonatomic, strong) EHRequest *messageStatusRequest;
@property (nonatomic, strong) EHRequest *videoDetailRequest;
@property (nonatomic, strong) EHRequest *courseCostRequest;
@property (nonatomic, strong) EHRequest *alipayRequest;
@property (nonatomic, strong) EHRequest *wxpayRequest;
@property (nonatomic, strong) EHRequest *feedbackRequest;
@property (nonatomic, strong) EHRequest *uploadFeedbackRequest;
@property (nonatomic, strong) EHRequest *modifyPwdRequest;
@property (nonatomic, strong) EHRequest *modifyNicknameRequest;
@property (nonatomic, strong) EHRequest *modifyEmailRequest;
@property (nonatomic, strong) EHRequest *modifySexRequest;
@property (nonatomic, strong) EHRequest *modifySignRequest;
@property (nonatomic, strong) EHRequest *buySingleRequest;
@property (nonatomic, strong) EHRequest *payRequest;
@property (nonatomic, strong) EHRequest *payOneRequest;
@property (nonatomic, strong) EHRequest *payRewardRequest;
@property (nonatomic, strong) EHRequest *deleteAccountRequest;

@end

@implementation EHHomeService

- (void)homeCourseListWithParam:(NSDictionary *)param successBlock:(void (^)(NSArray *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"courseType/typea.app") ;
    self.homeCourseRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        if ([response isKindOfClass:[NSArray class]]) {
            NSArray *courseArray = [EHHomeCourseData mj_objectArrayWithKeyValuesArray:response];
            // 只缓存一次
            if (![EHCacheManager hasObjectForCachedKey:(NSString *)kHomeDataKey]) {
                [EHCacheManager cacheObject:courseArray forKey:(NSString *)kHomeDataKey];
            }
            successBlock(courseArray) ;
        }else {
            successBlock(nil);
        }
    } error:^(EHError *error) {
        if (![Utils isReachable]) {
            // 无网络时读取缓存数据
            if ([EHCacheManager hasObjectForCachedKey:(NSString *)kHomeDataKey]) {
                successBlock([EHCacheManager objectForCachedKey:(NSString *)kHomeDataKey]);
                return;
            }
        }
        errorBlock(error);
    }] ;
}

- (void)homeBannerDataWithParam:(NSDictionary *)param successBlock:(void (^)(EHHomeBannerData *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"firstpic/get.app") ;
    self.homeBannerRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        if ([response isKindOfClass:[NSDictionary class]]) {
            EHHomeBannerData *bannerData = [EHHomeBannerData mj_objectWithKeyValues:response];
            // 只缓存一次
            if (![EHCacheManager hasObjectForCachedKey:(NSString *)kHomeBannerKey]) {
                [EHCacheManager cacheObject:bannerData forKey:(NSString *)kHomeBannerKey];
            }
            successBlock(bannerData) ;
        }else {
            successBlock(nil);
        }
    } error:^(EHError *error) {
        if (![Utils isReachable]) {
            // 从缓存中读取数据
            if ([EHCacheManager hasObjectForCachedKey:(NSString *)kHomeBannerKey]) {
                EHHomeBannerData *bannerData = [EHCacheManager objectForCachedKey:(NSString *)kHomeBannerKey];
                successBlock(bannerData);
                return;
            }
        }
        errorBlock(error);
    }] ;
}

- (void)courseListWithParam:(NSDictionary *)param successBlock:(void (^)(NSArray *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *cachedKey = EHCourseListKey(param[@"aid"]);
    NSString *url = EHHttpRestURL(@"courseType/typeb.app") ;
    self.courseListRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        NSArray *courseArray = [EHCourseListData mj_objectArrayWithKeyValuesArray:response];
        // 只缓存一次
        if (![EHCacheManager hasObjectForCachedKey:cachedKey]) {
            [EHCacheManager cacheObject:courseArray forKey:cachedKey];
        }
        successBlock(courseArray) ;
    } error:^(EHError *error) {
        if (![Utils isReachable]) {
            // 从缓存中读取数据
            EHLog(@"courselist cachedkey = %@", cachedKey);
            if ([EHCacheManager hasObjectForCachedKey:cachedKey]) {
                NSArray *cachedList = [EHCacheManager objectForCachedKey:cachedKey];
                successBlock(cachedList);
                return;
            }
        }
        errorBlock(error);
    }] ;
}

- (void)menuListWithParam:(NSDictionary *)param successBlock:(void (^)(NSArray *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *cachedKey = EHCourseMenuListKey(param[@"cid"]);
    NSString *url = EHHttpRestURL(@"course/typec.app");
//    NSString *url = EHHttpRestURL(@"courseType/typeb.app");
    ///app/courseType/typeb.app

    self.menuListRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSArray *detailArray =
        [EHVideoMenuModel mj_objectArrayWithKeyValuesArray:responseDictinary[EHResponseKey]];
        // 只缓存一次
        if (![EHCacheManager hasObjectForCachedKey:cachedKey]) {
            [EHCacheManager cacheObject:detailArray forKey:cachedKey];
        }
        successBlock(detailArray);
    } error:^(EHError *error) {
        if (![Utils isReachable]) {
            // 从缓存中读取数据
            EHLog(@"menu list cachedkey = %@", cachedKey);
            if ([EHCacheManager hasObjectForCachedKey:cachedKey]) {
                NSArray *cachedList = [EHCacheManager objectForCachedKey:cachedKey];
                successBlock(cachedList);
                return;
            }
        }
        errorBlock(error);
    }];
}

- (void)videoDetailWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"power/getinline.app");
    
    self.videoDetailRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock];
}

- (void)courseDetailWithParam:(NSDictionary *)param successBlock:(void (^)(EHCourseDetail *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *cachedKey = EHCourseDetailKey(param[@"id"]);
    NSString *url = EHHttpRestURL(@"course/getdetail.app");
    
    self.courseDetailRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        EHCourseDetail *courseDetail = [EHCourseDetail mj_objectWithKeyValues:responseDictinary[EHResponseKey]];
        // 只缓存一次
        if (![EHCacheManager hasObjectForCachedKey:cachedKey]) {
            [EHCacheManager cacheObject:courseDetail forKey:cachedKey];
        }
        successBlock(courseDetail);
    } error:^(EHError *error) {
        if (![Utils isReachable]) {
            // 从缓存中读取数据
            EHLog(@"coursedetail cachedkey = %@", cachedKey);
            if ([EHCacheManager hasObjectForCachedKey:cachedKey]) {
                EHCourseDetail *cachedDetail = [EHCacheManager objectForCachedKey:cachedKey];
                successBlock(cachedDetail);
                return;
            }
        }
        errorBlock(error);
    }];
}

- (void)courseCostWithParam:(NSDictionary *)param successBlock:(void (^)(NSString *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *cachedKey = EHCourseMoneyKey(param[@"id"]);
    NSString *url = EHHttpRestURL(@"course/totalMoney.app");
    
    self.courseCostRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSString *courseMoney = responseDictinary[@"totalMoney"];
        // 只缓存一次
        if (![EHCacheManager hasObjectForCachedKey:cachedKey]) {
            [EHCacheManager cacheObject:courseMoney forKey:cachedKey];
        }
        successBlock(courseMoney);
    } error:^(EHError *error) {
        if (![Utils isReachable]) {
            // 从缓存中读取数据
            EHLog(@"course money cachedkey = %@", cachedKey);
            if ([EHCacheManager hasObjectForCachedKey:cachedKey]) {
                NSString *cachedMoney = [EHCacheManager objectForCachedKey:cachedKey];
                successBlock(cachedMoney);
                return;
            }
        }
        errorBlock(error);
    }];
}

/// message ///

- (void)messageStatusWithParam:(NSDictionary *)param successBlock:(void (^)(NSInteger))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    self.messageStatusRequest =
    [EHMessageService messageStatusWithParam:param successBlock:successBlock errorBlock:errorBlock];
}

/// pay ///

- (void)alipayOrderWithParam:(NSDictionary *)param successBlock:(void (^)(NSString *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"account/recharge.app");
    
    self.alipayRequest = [self sendPostRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary[@"orderStr"]);
    } error:errorBlock];
}

- (void)wxpayOrderWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"account/recharge2.app");
    
    self.wxpayRequest = [self sendPostRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock];
}

/// feedback: 包含上传图片的功能 ///

- (void)feedbackWithComment:(NSString *)comment
                imageInfo:(NSDictionary *)imageInfo
             successBlock:(void (^)(NSString *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    NSString *url = EHHttpRestURL(@"feedback/add.app");
    
    NSMutableArray *formDataArray = [NSMutableArray array];
    for (NSString *imageName in imageInfo) {
        EHFormData *formData = [[EHFormData alloc] init];
        formData.data = imageInfo[imageName];
        formData.name = @"luoboimg";
        formData.filename = imageName;
        formData.mimeType = [Utils imageTypeForData:formData.data];
        [formDataArray addObject:formData];
    }
    
    NSDictionary *param = @{@"id": [EHUserInfo sharedUserInfo].Id,
                            @"comment": comment};
    
    self.feedbackRequest = [self postRequestWithURL:url
                                             params:param
                                      formDataArray:formDataArray
                                            success:^(NSDictionary *responseDictinary) {
        NSString *code = responseDictinary[EHResponseCode];
        if ([code isEqualToString:EHSuccessCode]) {
            successBlock(nil);
        }else {
            successBlock(@"提交失败,请重试");
        }
    } error:errorBlock];
}

/// modify userInfo ///

- (void)modifyPwdWithParam:(NSDictionary *)param successBlock:(void (^)(NSString *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    NSString *url = EHHttpRestURL(@"cus/updatePwd.app");
    self.modifyPwdRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSString *code = responseDictinary[EHResponseCode];
        if ([code isEqualToString:EHSuccessCode]) {
            successBlock(nil);
        }else {
            successBlock(responseDictinary[@"errorMsg"]);
        }
    } error:errorBlock];
}

- (void)modifyNicknameWithParam:(NSDictionary *)param successBlock:(void (^)(NSString *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    NSString *url = EHHttpRestURL(@"cus/updateNickName.app");
    self.modifyNicknameRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSString *code = responseDictinary[EHResponseCode];
        if ([code isEqualToString:EHSuccessCode]) {
            successBlock(nil);
        }else {
            successBlock(responseDictinary[@"errorMsg"]);
        }
    } error:errorBlock];
}

- (void)modifyEmailWithParam:(NSDictionary *)param successBlock:(void (^)(NSString *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    NSString *url = EHHttpRestURL(@"cus/updateEmail.app");
    self.modifyEmailRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSString *code = responseDictinary[EHResponseCode];
        if ([code isEqualToString:EHSuccessCode]) {
            successBlock(nil);
        }else {
            successBlock(responseDictinary[@"errorMsg"]);
        }
    } error:errorBlock];
}

- (void)modifySexWithParam:(NSDictionary *)param successBlock:(void (^)(NSString *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    NSString *url = EHHttpRestURL(@"cus/updateSex.app");
    self.modifySexRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSString *code = responseDictinary[EHResponseCode];
        if ([code isEqualToString:EHSuccessCode]) {
            successBlock(nil);
        }else {
            successBlock(responseDictinary[@"errorMsg"]);
        }
    } error:errorBlock];
}

- (void)modifySignatureWithParam:(NSDictionary *)param successBlock:(void (^)(NSString *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"cus/personSign.app");
    self.modifySignRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSString *code = responseDictinary[EHResponseCode];
        if ([code isEqualToString:EHSuccessCode]) {
            successBlock(nil);
        }else {
            successBlock(responseDictinary[@"errorMsg"]);
        }
    } error:errorBlock];
}

- (void)alipaySingalClassWithParam:(NSDictionary *)param successBlock:(void (^)(NSString *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"Ufind/alipay.app");
    self.buySingleRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary[@"orderStr"]);
    } error:errorBlock];
}

- (void)weixinPaySingalClassWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"Ufind/weixin.app");
    self.buySingleRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock];
}

- (void)payForCourseWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"apple/buy.app");
    self.payRequest = [self sendJSONPostRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock];
}

- (void)payForOneWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"apple/buyOne.app");
    self.payOneRequest = [self sendJSONPostRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock];
}

- (void)payForGiftWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"apple/reward.app");
    self.payRewardRequest = [self sendJSONPostRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock];
}

// 账号注销
- (void)deleteAccountWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"cus/cancellationOfAccount.app");
    self.deleteAccountRequest = [self sendJSONPostRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock];
}

/////////////////////////////////////////////////////

- (void)dealloc {
    [self.homeBannerRequest cancelRequest];
    [self.homeCourseRequest cancelRequest];
    [self.menuListRequest cancelRequest];
    [self.courseListRequest cancelRequest];
    [self.messageStatusRequest cancelRequest];
    [self.videoDetailRequest cancelRequest];
    [self.courseCostRequest cancelRequest];
    [self.alipayRequest cancelRequest];
    [self.wxpayRequest cancelRequest];
    [self.feedbackRequest cancelRequest];
    [self.uploadFeedbackRequest cancelRequest];
    [self.modifyPwdRequest cancelRequest];
    [self.modifyNicknameRequest cancelRequest];
    [self.modifyEmailRequest cancelRequest];
    [self.modifySexRequest cancelRequest];
    [self.modifySignRequest cancelRequest];
    [self.buySingleRequest cancelRequest];
    [self.payRequest cancelRequest];
    [self.payOneRequest cancelRequest];
    [self.payRewardRequest cancelRequest];
    [self.deleteAccountRequest cancelRequest];
}

@end
