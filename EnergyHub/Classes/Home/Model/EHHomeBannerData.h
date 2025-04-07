//
//  EHHomeBannerData.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/19.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHBaseDataModel.h"

@interface EHHomeBannerData : EHBaseDataModel<NSCoding>

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
// banner
@property (nonatomic, copy) NSString *pone;
@property (nonatomic, copy) NSString *ptwo;
@property (nonatomic, copy) NSString *pthree;
// 推荐
@property (nonatomic, copy) NSString *pfour;
@property (nonatomic, copy) NSString *pfive;


- (NSArray *)bannerImages;
- (BOOL)hasRecommend;

@end
