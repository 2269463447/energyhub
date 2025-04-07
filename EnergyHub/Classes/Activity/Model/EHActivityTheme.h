//
//  EHActivityTheme.h
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/4/3.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EHActivityTheme : NSObject

typedef NS_ENUM(NSInteger, ActivityTheme) {
    ActivityThemeJuHuiJiaoYou = 0,
    ActivityThemeLvYouChuXing = 1,
    ActivityThemeYueQiTiYan = 2,
    ActivityThemeLaoNianJiaoYou = 3,
    ActivityThemeYiQiJianShen = 4,
    ActivityThemeJiNengPeiXun = 5,
    ActivityThemeHangYeJiaoLiu = 6,
    ActivityThemeXiangQinJiaoYou = 7,
    ActivityThemeDuShuHui = 8,
    ActivityThemeChuangYeJiaoLiu = 9,
    ActivityThemeYiQiGongYi = 10,
    ActivityThemeDianShangJiaoLiu = 11,
    ActivityThemeQinZiTiYan = 12,
    ActivityThemeShangJiaDaCu = 13,
    ActivityThemeMianFeiJiNeng = 14,
    ActivityThemeZiDingYi = 15
};

FOUNDATION_EXPORT NSString * ActivityThemeTitle(ActivityTheme theme);

@end

NS_ASSUME_NONNULL_END
