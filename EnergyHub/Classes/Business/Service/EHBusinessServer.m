//
//  EHBusinessServer.m
//  EnergyHub
//
//  Created by cpf on 2017/8/14.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHBusinessServer.h"

@interface EHBusinessServer ()

@property (nonatomic, strong) EHRequest *companyRequest;
@property (nonatomic, strong) EHRequest *cooperateRequest;
@property (nonatomic, strong) EHRequest *joinRequest;

@end

@implementation EHBusinessServer

- (void)businessAddCompanyDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"inv/add.app") ;
    self.companyRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock] ;
}

- (void)businessAddCooperateDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"bus/add.app") ;
    self.cooperateRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock] ;
}

- (void)eliteJoinDataWithParam:(NSDictionary *)param successBlock:(void (^)(id obj))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"elite/add.app");
//    NSString *url = [NSString stringWithFormat:@"http://www.sycy888.com/app/elite/add.app?joinContent=%@&joinType=%@&contact=%@", param[@"joinContent"], param[@"joinType"], param[@"contact"]];
//    NSString *newUrl = [url stringByAddingPercentEscapesUsingEncoding:
//                        NSUTF8StringEncoding];
//    NSDictionary *param = @{@"joinContent":joinContent,
//                            @"joinType":joinType,
//                            @"contact":self.phoneTextField.text};
    self.joinRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock] ;
}

- (void)dealloc {
    [self.companyRequest cancelRequest];
    [self.cooperateRequest cancelRequest];
    [self.joinRequest cancelRequest];
}

@end
