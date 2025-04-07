//
//  EHActivityTag.h
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/4/3.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EHActivityTag : NSObject
typedef NS_ENUM(NSInteger, ActivityTag) {
    ActivityTagMeiZiDuo = 0,
    ActivityTagShuaiGeDuo = 1,
    ActivityTagRenMaiDuo = 2,
    ActivityTagMianFei = 3,
    ActivityTagXianShang = 4,
    ActivityTagGuanLiJiNeng = 5,
    ActivityTagQianDuo = 6,
    ActivityTagLaoShiMeiHao = 7,
    ActivityTagLaoBanDuo = 8,
    ActivityTagZhenXinXiangQin = 9,
    ActivityTagRongZiLuYan = 10,
    ActivityTagXinXiDuo = 11,
    ActivityTagGaiNianDuo = 12,
    ActivityTagDianZiDuo = 13,
    ActivityTagZhaoTongLeiRen = 14,
    ActivityTagKaiKuoYanJie = 15,
    ActivityTagYouHuiZu = 16,
    ActivityTagMianFeiXue = 17,
    ActivityTagZiDingYi = 18
};

FOUNDATION_EXPORT NSString * ActivityTagTitle(ActivityTag tag);
FOUNDATION_EXPORT UIColor * ActivityTagTextColor(ActivityTag tag);
FOUNDATION_EXPORT UIColor * ActivityTagBackgroundColor(ActivityTag tag);

@end

NS_ASSUME_NONNULL_END
