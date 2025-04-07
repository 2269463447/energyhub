//
//  EHHomeBannerData.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/19.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHHomeBannerData.h"

@implementation EHHomeBannerData


MJCodingImplementation


- (NSArray *)bannerImages {
    
    return @[self.pone, self.ptwo, self.pthree];
}

- (BOOL)hasRecommend {
    
    return self.pfour != nil || self.pfour != nil;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@", self.title, self.pone, self.ptwo, self.pthree, self.pfour, self.pfive];
}

@end
