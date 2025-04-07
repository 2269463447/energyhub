//
//  EHActivityTag.m
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/4/3.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

#import "EHActivityTag.h"

@implementation EHActivityTag

NSString * ActivityTagTitle(ActivityTag tag) {
    switch (tag) {
        case ActivityTagMeiZiDuo: return @"妹子多";
        case ActivityTagShuaiGeDuo: return @"帅哥多";
        case ActivityTagRenMaiDuo: return @"人脉多";
        case ActivityTagMianFei: return @"免费";
        case ActivityTagXianShang: return @"线上活动";
        case ActivityTagGuanLiJiNeng: return @"管理技能";
        case ActivityTagQianDuo: return @"钱多";
        case ActivityTagLaoShiMeiHao: return @"老师美好";
        case ActivityTagLaoBanDuo: return @"老伴多";
        case ActivityTagZhenXinXiangQin: return @"真心相亲";
        case ActivityTagRongZiLuYan: return @"融资路演";
        case ActivityTagXinXiDuo: return @"信息多";
        case ActivityTagGaiNianDuo: return @"概念多";
        case ActivityTagDianZiDuo: return @"点子多";
        case ActivityTagZhaoTongLeiRen: return @"找同类人";
        case ActivityTagKaiKuoYanJie: return @"开阔眼界";
        case ActivityTagYouHuiZu: return @"优惠足";
        case ActivityTagMianFeiXue: return @"免费学";
        case ActivityTagZiDingYi: return @"自定义";
        default: return @"";
    }
}

UIColor * ActivityTagTextColor(ActivityTag tag) {
    switch (tag) {
        case ActivityTagMeiZiDuo: return [UIColor colorWithHexString:@"#D81B60"];
        case ActivityTagShuaiGeDuo: return [UIColor colorWithHexString:@"#388E3C"];
        case ActivityTagRenMaiDuo: return [UIColor colorWithHexString:@"#1976D2"];
        case ActivityTagMianFei: return [UIColor colorWithHexString:@"#303F9F"];
        case ActivityTagXianShang: return [UIColor colorWithHexString:@"#512DA8"];
        case ActivityTagGuanLiJiNeng: return [UIColor colorWithHexString:@"#EF6C00"];
        case ActivityTagQianDuo: return [UIColor colorWithHexString:@"#FF8F00"];
        case ActivityTagLaoShiMeiHao: return [UIColor colorWithHexString:@"#6D4C41"];
        case ActivityTagLaoBanDuo: return [UIColor colorWithHexString:@"#00796B"];
        case ActivityTagZhenXinXiangQin: return [UIColor colorWithHexString:@"#C2185B"];
        case ActivityTagRongZiLuYan: return [UIColor colorWithHexString:@"#D84315"];
        case ActivityTagXinXiDuo: return [UIColor colorWithHexString:@"#0288D1"];
        case ActivityTagGaiNianDuo: return [UIColor colorWithHexString:@"#5D4037"];
        case ActivityTagDianZiDuo: return [UIColor colorWithHexString:@"#7B1FA2"];
        case ActivityTagZhaoTongLeiRen: return [UIColor colorWithHexString:@"#303F9F"];
        case ActivityTagKaiKuoYanJie: return [UIColor colorWithHexString:@"#00796B"];
        case ActivityTagYouHuiZu: return [UIColor colorWithHexString:@"#0097A7"];
        case ActivityTagMianFeiXue: return [UIColor colorWithHexString:@"#388E3C"];
        case ActivityTagZiDingYi: return [UIColor colorWithHexString:@"#757575"];
        default: return [UIColor blackColor];
    }
}

UIColor * ActivityTagBackgroundColor(ActivityTag tag) {
    switch (tag) {
        case ActivityTagMeiZiDuo: return [UIColor colorWithHexString:@"#FCE4EC"];
        case ActivityTagShuaiGeDuo: return [UIColor colorWithHexString:@"#E8F5E9"];
        case ActivityTagRenMaiDuo: return [UIColor colorWithHexString:@"#E3F2FD"];
        case ActivityTagMianFei: return [UIColor colorWithHexString:@"#E8EAF6"];
        case ActivityTagXianShang: return [UIColor colorWithHexString:@"#EDE7F6"];
        case ActivityTagGuanLiJiNeng: return [UIColor colorWithHexString:@"#FFF3E0"];
        case ActivityTagQianDuo: return [UIColor colorWithHexString:@"#FFF8E1"];
        case ActivityTagLaoShiMeiHao: return [UIColor colorWithHexString:@"#EFEBE9"];
        case ActivityTagLaoBanDuo: return [UIColor colorWithHexString:@"#E0F2F1"];
        case ActivityTagZhenXinXiangQin: return [UIColor colorWithHexString:@"#FCE4EC"];
        case ActivityTagRongZiLuYan: return [UIColor colorWithHexString:@"#FFEBEE"];
        case ActivityTagXinXiDuo: return [UIColor colorWithHexString:@"#E1F5FE"];
        case ActivityTagGaiNianDuo: return [UIColor colorWithHexString:@"#EFEBE9"];
        case ActivityTagDianZiDuo: return [UIColor colorWithHexString:@"#F3E5F5"];
        case ActivityTagZhaoTongLeiRen: return [UIColor colorWithHexString:@"#E8EAF6"];
        case ActivityTagKaiKuoYanJie: return [UIColor colorWithHexString:@"#E0F2F1"];
        case ActivityTagYouHuiZu: return [UIColor colorWithHexString:@"#E0F7FA"];
        case ActivityTagMianFeiXue: return [UIColor colorWithHexString:@"#E8F5E9"];
        case ActivityTagZiDingYi: return [UIColor colorWithHexString:@"#F5F5F5"];
        default: return [UIColor whiteColor];
    }
}
@end
