//
//  EHPayDownloadUserInfoCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2017/9/3.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHPayDownloadUserInfoCell.h"


@interface EHPayDownloadUserInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;

@end

@implementation EHPayDownloadUserInfoCell


+ (CGFloat)cellHeight {
    
    return 95.f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _nicknameLabel.textColor = EHFontColor;
    _userAccountLabel.textColor = EHFontColor;
    _userEmailLabel.textColor = EHFontColor;
    // userinfo
    _nicknameLabel.text = [NSString stringWithFormat:@"昵称：%@", [EHUserInfo sharedUserInfo].nickName];
    _userAccountLabel.text = [NSString stringWithFormat:@"会员账号：%@", [EHUserInfo sharedUserInfo].userName];
    NSString *email = [EHUserInfo sharedUserInfo].email;
    if (!email) {
        email = @"暂无";
    }
    _userEmailLabel.text = [NSString stringWithFormat:@"邮箱账号：%@", email];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
