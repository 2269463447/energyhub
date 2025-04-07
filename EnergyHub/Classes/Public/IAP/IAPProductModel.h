//
//  IAPProductModel.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/11/15.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPProductModel : NSObject

// Products/Purchases are organized by category
@property (nonatomic, copy) NSString *name;
//  List of products/purchases
@property (nonatomic, strong) NSArray *elements;

// Create a model object
-(instancetype)initWithName:(NSString *)name elements:(NSArray *)elements NS_DESIGNATED_INITIALIZER;

@end
