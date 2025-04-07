//
//  EHMessageData.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/25.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseDataModel.h"

@interface EHMessageData : EHBaseDataModel

@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *zhuangtai;

@end
