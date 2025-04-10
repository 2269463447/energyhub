//
//  EHActivityItem.h
//  EnergyHub
//
//  Created by gaojuyan on 2024/6/9.
//  Copyright © 2024 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHActivityTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface EHActivityItem : NSObject

@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy, nullable) NSString *detail;
@property (nonatomic, copy, nullable) NSString *startTime;
@property (nonatomic, copy, nullable) NSString *endTime;
@property (nonatomic, copy, nullable) NSString *price;
@property (nonatomic, copy, nullable) NSString *contactInformation;
@property (nonatomic, copy, nullable) NSString *address;
@property (nonatomic, copy, nullable) NSString *theme; // 如果你打算用枚举可以转为 ActivityTheme
@property (nonatomic, copy, nullable) NSString *tag;
@property (nonatomic, copy, nullable) NSString *coverUrl;
@property (nonatomic, copy, nullable) NSString *status;
@property (nonatomic, copy, nullable) NSString *userName;

@property (nonatomic, copy, nullable) NSString *provinceCode;
@property (nonatomic, copy, nullable) NSString *cityCode;
@property (nonatomic, copy, nullable) NSString *districtCode;

@property (nonatomic, copy, nullable) NSString *provinceCodeName;
@property (nonatomic, copy, nullable) NSString *cityCodeName;
@property (nonatomic, copy, nullable) NSString *districtCodeName;

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) BOOL isDel;
@property (nonatomic, assign) NSInteger signUpCount;

@property (nonatomic, copy) NSString *gmtCreate;
@property (nonatomic, copy) NSString *gmtModified;
@property (nonatomic, copy, nullable) NSString *approvalReason;

@end

NS_ASSUME_NONNULL_END
