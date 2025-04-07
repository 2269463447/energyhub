//
//  EHRecordHeaderCell.m
//  EnergyHub
//
//  Created by cpf on 2017/9/4.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHRecordHeaderCell.h"
#import "EHBaseService.h"
#import <ReactiveObjC.h>
#import "NSString+EHMoney.h"

@interface EHRecordHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 已花费
 */
@property (weak, nonatomic) IBOutlet UILabel *alreadyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *alreadyPayImgView;
@property (weak, nonatomic) IBOutlet UIImageView *revenueImgView;
@property (weak, nonatomic) IBOutlet UIImageView *withdrawalImgView;
@property (weak, nonatomic) IBOutlet UILabel *recenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *withdrawalLabel;

/**
 已花费金额
 */
@property (weak, nonatomic) IBOutlet UILabel *alreadyPayLabel;

/**
 余额
 */
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

/**
 已消费
 */
@property (weak, nonatomic) IBOutlet UIButton *alreadyPayBtn;

/**
 收入
 */
@property (weak, nonatomic) IBOutlet UIButton *revenueBtn;

/**
 提现
 */
@property (weak, nonatomic) IBOutlet UIButton *withdrawalBtn;

@end

@implementation EHRecordHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImgView.layer.masksToBounds = YES;
    self.iconImgView.layer.cornerRadius = _iconImgView.width * .5;
    
    
    self.withdrawalBtn.hidden = YES;
    self.withdrawalImgView.hidden = YES;
    self.withdrawalLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserInfo:(EHUserInfo *)userInfo {
    _userInfo = userInfo;
    NSURL *url = [NSURL URLWithString:EHHttpRestURL(userInfo.picture)];
    UIImage *placeholderImg = [UIImage imageNamed:@"background"];
    [self.iconImgView sd_setImageWithURL:url placeholderImage:placeholderImg];
    self.nameLabel.text = userInfo.nickName;
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    NSString *blance = [data objectForKey:@"number"];
//    blance = [NSString uMoenyChangeToRMBString:blance];
    NSString *alreadyPay = [data objectForKey:@"xiaofei"];
    
//    NSString *moeny = [NSString stringWithFormat:@"%.2f",     (alreadyPay.floatValue * 1.3)/10.0];
    
    self.alreadyPayLabel.text = [alreadyPay stringByAppendingString:@"U币"];

//    alreadyPay = [NSString uMoenyChangeToRMBString:alreadyPay];
//    self.alreadyPayLabel.text = [alreadyPay stringByAppendingString:@"元"];
    self.balanceLabel.text = [blance stringByAppendingString:@"U币"];
}

- (IBAction)alreadyPayBtnAction:(id)sender {
    [self setAlreadyBtnIsSeleted:YES];
    [self setRecenueBtnIsSelected:NO];
    [self setWithdrawalBtnIsSelected:NO];
}

- (IBAction)recenueBtnAction:(id)sender {
    [self setAlreadyBtnIsSeleted:NO];
    [self setRecenueBtnIsSelected:YES];
    [self setWithdrawalBtnIsSelected:NO];
}

- (IBAction)withdrawalBtnAction:(id)sender {
    [self setAlreadyBtnIsSeleted:NO];
    [self setRecenueBtnIsSelected:NO];
    [self setWithdrawalBtnIsSelected:YES];
}

- (void)setAlreadyBtnIsSeleted:(BOOL)isSelect {
    if (isSelect) {
        self.alreadyPayLabel.textColor = EHMainColor;
        self.alreadyLabel.textColor = EHMainColor;
        self.alreadyPayImgView.image = [UIImage imageNamed:@"consumption"];
        if ([_delegate respondsToSelector:@selector(didSelectView:index:)]) {
            [_delegate didSelectView:self index:0];
        }
    }else{
        self.alreadyPayLabel.textColor = [UIColor blackColor];
        self.alreadyLabel.textColor = [UIColor blackColor];
        self.alreadyPayImgView.image = [UIImage imageNamed:@"consumption_normal"];
    }
}

- (void)setRecenueBtnIsSelected:(BOOL)isSelected {
    if (isSelected) {
        self.revenueImgView.image = [UIImage imageNamed:@"income"];
        self.recenueLabel.textColor = EHMainColor;
        if ([_delegate respondsToSelector:@selector(didSelectView:index:)]) {
            [_delegate didSelectView:self index:1];
        }
    }else{
        self.revenueImgView.image = [UIImage imageNamed:@"income_normal"];
        self.recenueLabel.textColor = [UIColor blackColor];
    }
}

- (void)setWithdrawalBtnIsSelected:(BOOL)isSelected {
    if (isSelected) {
        self.withdrawalImgView.image = [UIImage imageNamed:@"withdrawal"];
        self.withdrawalLabel.textColor = EHMainColor;
        if ([_delegate respondsToSelector:@selector(didSelectView:index:)]) {
            [_delegate didSelectView:self index:2];
        }
    }else{
        self.withdrawalImgView.image = [UIImage imageNamed:@"withdrawal_normal"];
        self.withdrawalLabel.textColor = [UIColor blackColor];
    }
}

@end
