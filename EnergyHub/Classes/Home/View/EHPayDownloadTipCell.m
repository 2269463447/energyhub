//
//  EHPayDownloadTipCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/3.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHPayDownloadTipCell.h"

const NSString *tipInfo = @"离线视频是为会员提供便捷观看的增值服务，购买之后可以在没有网络的环境下离线学习，方便学员在各种事件段进行充电学习！";

@interface EHPayDownloadTipCell()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation EHPayDownloadTipCell

+ (CGFloat)cellHeight {
    
    return [tipInfo boundingRectWithSize:CGSizeMake(kScreenWidth - 30, CGFLOAT_MAX)
                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                              attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                 context:NULL].size.height + 15;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.tipLabel.textColor = EHFontColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
