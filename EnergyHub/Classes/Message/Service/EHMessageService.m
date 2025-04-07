//
//  EHMessageService.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHMessageService.h"


@interface EHMessageService ()

@property (nonatomic, strong) EHRequest *messageListRequest;
@property (nonatomic, strong) EHRequest *updateMessageRequest;
@property (nonatomic, strong) EHRequest *messageContentRequest;

@end

@implementation EHMessageService


- (void)messageListWithParam:(NSDictionary *)param successBlock:(void (^)(NSArray *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"message/getTitle.app") ;
    self.messageListRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        NSDictionary *response = responseDictinary[EHResponseKey];
        successBlock([EHMessageData mj_objectArrayWithKeyValuesArray:response]);
    } error:errorBlock] ;
}

- (void)updateMessageWithParam:(NSDictionary *)param successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"cus/updateMessage.app") ;
    self.updateMessageRequest =
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock(responseDictinary);
    } error:errorBlock] ;
}

+ (EHRequest *)messageStatusWithParam:(NSDictionary *)param successBlock:(void (^)(NSInteger))successBlock errorBlock:(EHErrorBlock)errorBlock {
    
    NSString *url = EHHttpRestURL(@"cus/selectMessage.app") ;
    return
    [self sendGetRequestWithURL:url params:param success:^(NSDictionary *responseDictinary) {
        successBlock([responseDictinary[@"data"] integerValue]); // 1代表有新消息
    } error:errorBlock] ;
}

#pragma mark - dealloc

- (void)dealloc {
    
    [self.messageListRequest cancelRequest];
    [self.updateMessageRequest cancelRequest];
}


@end
