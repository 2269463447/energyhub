//
//  JEBaseDataModel.m
//  JiaeD2C
//
//  Created by gaojuyan on 16/5/11.
//  Copyright © 2016年 www.jiae.com. All rights reserved.
//

#import "EHBaseDataModel.h"

@implementation EHBaseDataModel

// vc中用valueForKey取值，可能会出现新增的字段
- (id)valueForUndefinedKey:(NSString *)key {
    // 暂时不处理
    NSLog(@"valueForUndefinedKey: [%@] in class: [%@]", key, NSStringFromClass(self.class));
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"setValue:[%@] forUndefinedKey: [%@] in class: [%@]", value, key, NSStringFromClass(self.class));
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"unrecognized selector: [%@] send to [%@]", NSStringFromSelector(aSelector), NSStringFromClass(self.class));
}

@end
