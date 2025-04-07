//
//  EHRegisterProtocolView.h
//  EnergyHub
//
//  Created by cpf on 2017/9/19.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AgreeProtocolBlock)();

@interface EHRegisterProtocolView : UIView

@property (nonatomic, copy) AgreeProtocolBlock agreeBlock;

@end
