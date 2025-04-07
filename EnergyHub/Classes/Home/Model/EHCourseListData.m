//
//  EHCourseListData.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/8/21.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHCourseListData.h"

@implementation EHCourseListData

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"courseId": @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"typecs": [EHCourseItem class]};
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@, %@, %@, course count: %@", self.name, self.courseId, self.icon, @(self.typecs.count)];
}

@end
