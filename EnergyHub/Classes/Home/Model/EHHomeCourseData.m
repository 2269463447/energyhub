//
//  EHHomeCourseData.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/19.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHHomeCourseData.h"

@implementation EHHomeCourseData

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"courseId": @"id"};
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@, %@, %@", self.name, self.courseId, self.img];
}

@end
