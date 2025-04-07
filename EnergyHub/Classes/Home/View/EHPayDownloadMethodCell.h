//
//  EHPayDownloadMethodCell.h
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/3.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHBaseTableViewCell.h"

@protocol EHPayDownloadMethodDelegate <NSObject>

- (void)didSelectPayMethod:(PayMethod)method;

@end

@interface EHPayDownloadMethodCell : EHBaseTableViewCell

@property (nonatomic, weak) id<EHPayDownloadMethodDelegate> delegate;

@end
