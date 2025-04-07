//
//  EHActivityTheme.m
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/4/3.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

#import "EHActivityTheme.h"

@implementation EHActivityTheme
NSString * ActivityThemeTitle(ActivityTheme theme) {
    switch (theme) {
        case ActivityThemeJuHuiJiaoYou: return @"聚会交友";
        case ActivityThemeLvYouChuXing: return @"驴友出行";
        case ActivityThemeYueQiTiYan: return @"乐器体验";
        case ActivityThemeLaoNianJiaoYou: return @"老年交友";
        case ActivityThemeYiQiJianShen: return @"一起健身";
        case ActivityThemeJiNengPeiXun: return @"技能培训";
        case ActivityThemeHangYeJiaoLiu: return @"行业交流";
        case ActivityThemeXiangQinJiaoYou: return @"相亲交友";
        case ActivityThemeDuShuHui: return @"读书会";
        case ActivityThemeChuangYeJiaoLiu: return @"创业交流";
        case ActivityThemeYiQiGongYi: return @"一起公益";
        case ActivityThemeDianShangJiaoLiu: return @"电商交流";
        case ActivityThemeQinZiTiYan: return @"亲子体验";
        case ActivityThemeShangJiaDaCu: return @"商家大促";
        case ActivityThemeMianFeiJiNeng: return @"免费技能";
        case ActivityThemeZiDingYi: return @"自定义";
        default: return @"";
    }
}
@end
