//
//  EHMineHeaderCell.m
//  EnergyHub
//
//  Created by cpf on 2017/8/15.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHMineHeaderCell.h"
#import "UIImageView+LoadImage.h"
#import "EHGlobal.h"

@interface EHMineHeaderCell ()

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation EHMineHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatarView.layer.cornerRadius = _avatarView.width * .5;
    _avatarView.layer.masksToBounds = YES;
    //self.avatarButton.layer.cornerRadius = 33;
    //self.avatarButton.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = _avatarImageView.width * .5;
    _avatarImageView.layer.masksToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avatarUpdated:) name:AvatarUpdatedNotification object:nil];
}

- (void)loadUserInfo {
    EHUserInfo *userInfo = [EHUserInfo sharedUserInfo];
    NSString *nickname = userInfo.nickName ?: @"登录/注册";
    [self.loginButton setTitle:nickname forState:UIControlStateNormal];
    if (userInfo.picture) {
        NSString *avatarUrl = [NSString stringWithFormat:@"%@/%@", [[EHGlobal sharedGlobal] httpRestServer], userInfo.picture];
        [self.avatarImageView loadAvatarImageWithURL:avatarUrl];
    }else {
        self.avatarImageView.image = [UIImage imageNamed:@"background_image"];
    }
}

- (void)updateUserInfo {
    EHUserInfo *userInfo = [EHUserInfo sharedUserInfo];
    NSString *username = userInfo.nickName ?: @"能量库会员";
    [self.loginButton setTitle:username forState:UIControlStateNormal];
    if (userInfo.picture) {
        NSString *avatarUrl = [NSString stringWithFormat:@"%@/%@", [[EHGlobal sharedGlobal] httpRestServer], userInfo.picture];
        [self.avatarImageView loadAvatarImageWithURL:avatarUrl];
    }else {
        self.avatarImageView.image = [UIImage imageNamed:@"background_image"];
    }
}

- (void)avatarUpdated:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *avatarUrl = userInfo[@"avatar"];
    if (avatarUrl) {
        NSString *url = [NSString stringWithFormat:@"%@/%@", [[EHGlobal sharedGlobal] httpRestServer], avatarUrl];
        [self.avatarImageView loadAvatarImageWithURL:url];
    }
    NSString *nickname = userInfo[@"nickname"];
    if (nickname) {
        [self.loginButton setTitle:nickname forState:UIControlStateNormal];
    }
}

- (IBAction)loginAction:(UIButton *)sender {
    
    if (![sender.currentTitle isEqualToString:@"登录/注册"]) {
        return;
    }
    if (self.loginBlock) {
        self.loginBlock(sender);
    }
}

- (IBAction)avatarAction:(UIButton *)sender {

    !_avatarBlock ?: _avatarBlock(sender);
}

- (void)updateAvatarButtonTitle:(NSString *)title {
    
    [self.loginButton setTitle:title forState:UIControlStateNormal];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
