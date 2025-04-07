//
//  EHMineService.m
//  EnergyHub
//
//  Created by cpf on 2017/8/22.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHMineService.h"
#import "EHRecordModel.h"
#import "NSDictionary+Category.h"

@interface EHMineService ()

@property (nonatomic, strong) EHRequest *homeRequest;

@property (nonatomic, strong) EHRequest *updateAvatarRequest;

@property (nonatomic, strong) EHRequest *releasedCourseRequest;

@property (nonatomic, strong) EHRequest *registerRequest;

@property (nonatomic, strong) EHRequest *applyRequest;

@property (nonatomic, strong) EHRequest *costRequest;

@property (nonatomic, strong) EHRequest *recordRequest;

@property (nonatomic, strong) EHRequest *cashRequest;

@property (nonatomic, strong) EHRequest *verificationCodeRequest;

@property (nonatomic, strong) EHRequest *fastRegisterRequest;

@property (nonatomic, strong) EHRequest *qrCodeRequest;

@property (nonatomic, strong) EHRequest *emailRequest;
@property (nonatomic, strong) EHRequest *phoneRequest;
@property (nonatomic, strong) EHRequest *statusRequest;
@property (nonatomic, strong) EHRequest *cashHistoryRequest;
@property (nonatomic, strong) EHRequest *rechargeRecordRequest;

@property (nonatomic, strong) EHRequest *rechargeRequest;

@property (nonatomic, strong) EHRequest *tmpUserRequest;

@property (nonatomic, strong) EHRequest *teamRequest;
@property (nonatomic, strong) EHRequest *withdrawDetailRequest;
@property (nonatomic, strong) EHRequest *withdrawRequest;

@end

@implementation EHMineService

- (void)loginDataWithParam:(NSDictionary *)param successBlock:(void (^)(EHUserInfo *userInfo))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"cus/login.app") ;
    self.homeRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        if ([response isKindOfClass:[NSDictionary class]]) {
            successBlock([EHUserInfo mj_objectWithKeyValues:response]) ;
        }else {
            successBlock(nil);
        }
    } error:errorBlock] ;
}

- (void)registerDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"cus/register.app") ;
    self.registerRequest =
    [self sy_sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
//        NSDictionary *response = responseDictinary[EHResponseKey];
//        if ([response isKindOfClass:[NSDictionary class]]) {
//            successBlock(response) ;
//        }else {
//            successBlock(nil);
//        }
        successBlock(responseDictinary);
    } error:errorBlock] ;
}

- (void)updateAvatarImageWithParam:(NSDictionary *)param
                             image:(UIImage *)image
                         imageData:(NSData *)imageData
                          filename:(NSString *)filename
                      successBlock:(void (^)(NSString *))successBlock
                        errorBlock:(EHErrorBlock)errorBlock {
    // 必须要传image
    if (!image) {
        EHError *error = [EHError errorWithType:EHOtherError code:-100 message:@"上传图片出错！"];
        !errorBlock ? : errorBlock(error);
        return;
    }
    
    NSString *urlString = EHHttpRestURL(@"avatar/uploadPicture.app") ;
    EHFormData *formData = [[EHFormData alloc] init];
    formData.name = @"file";
    formData.filename = filename ?: @"head.jpg";
    if (imageData) {
        formData.data = imageData;
        formData.mimeType = [Utils imageTypeForData:imageData];
    }else {
        formData.data = UIImageJPEGRepresentation(image, 0.5);
        formData.mimeType = @"image/jpeg";
    }
    self.updateAvatarRequest =
    [self postRequestWithURL:urlString params:param formDataArray:@[formData] success:^(NSDictionary *responseDictinary) {
        NSString *code = responseDictinary[EHResponseCode];
        if ([code isEqualToString:EHSuccessCode]) {
            successBlock([responseDictinary objectForKey:@"img"]) ;
        }else {
            successBlock(nil) ;
        }
    } error:errorBlock];
}

- (void)releasedCourseWithParam:(NSDictionary *)param successBlock:(void (^)(NSArray *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"course/byteacher.app") ;
    self.releasedCourseRequest =
    [self sendPostRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        successBlock([EHReleasedCourseData mj_objectArrayWithKeyValuesArray:response]);
    } error:errorBlock] ;
}

- (void)applyTeacherDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"apply/teacher.app") ;
    self.applyRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
//        NSDictionary *response = responseDictinary[EHResponseKey];
//        if ([response isKindOfClass:[NSDictionary class]]) {
//            successBlock(response) ;
//        }else {
            successBlock(responseDictinary);
//        }
    } error:errorBlock] ;
}

- (void)releaseClassDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"apply/course.app") ;
    self.applyRequest =
    [self sy_sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock] ;
}

- (void)recordsConsumptionDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"account/expense.app") ;
    self.costRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        if ([response isKindOfClass:[NSDictionary class]]) {
            successBlock(response);
        }else {
            successBlock(responseDictinary);
        }
    } error:errorBlock] ;
}

- (void)costListDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    //income/findAll.app account/mingxi.app
    NSString *url = EHHttpRestURL(@"account/mingxi.app") ;
    self.recordRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        if ([response isKindOfClass:[NSDictionary class]]) {
            successBlock(response);
        }else {
            successBlock(responseDictinary);
        }
    } error:errorBlock] ;
}


- (void)cashWithdrawalListDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"kiting/findOne.app") ;
    self.cashHistoryRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        if ([response isKindOfClass:[NSDictionary class]]) {
            successBlock(response);
        }else {
            successBlock(responseDictinary);
        }
    } error:errorBlock] ;
}


- (void)applyForCashWithdrawalsDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"kiting/add.app") ;
    self.cashRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        if ([response isKindOfClass:[NSDictionary class]]) {
            successBlock(response);
        }else {
            successBlock(responseDictinary);
        }
    } error:errorBlock] ;
}


- (void)verificationCodeDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"send/getcode.app") ;
    self.verificationCodeRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        if ([response isKindOfClass:[NSDictionary class]]) {
            successBlock(response);
        }else {
            successBlock(responseDictinary);
        }
    } error:errorBlock] ;
}

- (void)fastRegisterDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"send/register.app") ;
    self.verificationCodeRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock] ;
}

- (void)appQRCodeWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {

    NSString *url = EHHttpRestURL(@"qrcode/selectAll.app") ;
    self.qrCodeRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        if ([response isKindOfClass:[NSDictionary class]]) {
            successBlock(response);
        }else {
            successBlock(nil);
        }
    } error:errorBlock] ;
}

- (void)emailFindPWdParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"cus/findPwd.app") ;
    self.emailRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        if ([response isKindOfClass:[NSDictionary class]]) {
            successBlock(response);
        }else {
            successBlock(responseDictinary);
        }
    } error:errorBlock] ;
}

- (void)phoneFindPWdParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"send/findPass.app") ;
    self.phoneRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        if ([response isKindOfClass:[NSDictionary class]]) {
            successBlock(response);
        }else {
            successBlock(responseDictinary);
        }
    } error:errorBlock] ;
}

- (void)teacherStatusWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"tandcStatus/whichStatus.app") ;
    self.statusRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock] ;
}

- (void)rechargeRecordParam:(NSDictionary *)param
               successBlock:(void (^)(NSDictionary *))successBlock
                 errorBlock:(EHErrorBlock)errorBlock {
    NSString *url = EHHttpRestURL(@"account/chongzhi.app") ;
    self.rechargeRecordRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:^(EHError *error) {
        
    }];
    
}

- (void)verifyAppstoreReceiptWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"apple/recharge.app") ;
    self.rechargeRequest =
    [self sendJSONPostRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock] ;
}


- (void)tmpUserLoginSuccessBlock:(void (^)(NSDictionary *))successBlock
                 errorBlock:(EHErrorBlock)errorBlock {
    NSString *url = EHHttpRestURL(@"ceshi/ceshi.app") ;
    self.tmpUserRequest = [self sendGetRequestWithURL:url params:nil success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:^(EHError *error) {
        
    }];
    
}

- (void)teamDetailWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock
                 errorBlock:(EHErrorBlock)errorBlock {
    NSString *url = EHHttpRestURL(@"team/teamDetail.app") ;
    self.teamRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock];
}

- (void)withdrawWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    NSString *url = EHHttpRestURL(@"team/cashout.app") ;
    self.withdrawRequest = [self sendJSONPostRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock];
}

-(void)withdrawDetailWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    NSString *url = EHHttpRestURL(@"team/getCanCashOut.app") ;
    self.withdrawDetailRequest = [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock];
}


#pragma mark - Memory

- (void)dealloc {
    
    [self.homeRequest cancelRequest];
    [self.registerRequest cancelRequest];
    [self.applyRequest cancelRequest];
    [self.recordRequest cancelRequest];
    [self.costRequest cancelRequest];
    [self.cashRequest cancelRequest];
    [self.verificationCodeRequest cancelRequest];
    [self.fastRegisterRequest cancelRequest];
    [self.updateAvatarRequest cancelRequest];
    [self.qrCodeRequest cancelRequest];
    [self.emailRequest cancelRequest];
    [self.phoneRequest cancelRequest];
    [self.statusRequest cancelRequest];
    [self.cashHistoryRequest cancelRequest];
    [self.rechargeRecordRequest cancelRequest];
    [self.rechargeRequest cancelRequest];
    [self.tmpUserRequest cancelRequest];
    [self.teamRequest cancelRequest];
    [self.withdrawRequest cancelRequest];
    [self.withdrawDetailRequest cancelRequest];
}

@end
