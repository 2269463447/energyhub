//
//  EHRegisterProtocolView.m
//  EnergyHub
//
//  Created by cpf on 2017/9/19.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHRegisterProtocolView.h"

@interface EHRegisterProtocolView ()

@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end

@implementation EHRegisterProtocolView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupData];
}

- (void)setupData {
    NSString *content = @"欢迎你加入本网站参与学习和讨论，我们将为你提供全方位的学习体验，为维护网上公共秩序和社会稳定，请你自觉遵守以下条款:\n\n一、不得利用本站危害国家安全、泄漏国家秘密、不得侵犯国家社会集体和公民的合法权益，不得利用本站制作、复制、传播以下信息:\n  (1)、煽动抗拒、破坏宪法和法律、行政法规实施的;\n  (2)、煽动破坏国家政权、推翻社会主义制度;\n  (3)、煽动分裂国家、破坏国家统一的;\n  (4)、煽动民族仇恨、民族歧视、破坏民族团结的;\n  (5)、捏造或者歪曲事实、散布谣言、扰乱社会秩序的;\n  (6)、公然侮辱他人或者捏造事实诽谤他人的、或者进行其它恶意攻击的;\n  (7)、损害国家机关信誉的;\n  (8)、其它违反宪法和法律行政法规的;\n  (9)、进行商业广告行为的;\n二、论坛讨论时相互尊重，对自己的言论和行为负责。\n三、凡是注册本站的会员，学员级别的会员充值的U币不可逆向提现，老师级别的会员因课程被点播而产生的收入可以提现为人民币\n四、因为论坛某些功能需要使用到你的个人信息(如密码找回、问题回复接收邮箱等)，所以请大家在后续的注册步骤时,填写正确的邮箱号。";

    
    self.contentLab.text = content;
}

- (IBAction)agreeProtocolAction:(id)sender {
    if (self.agreeBlock) {
        self.agreeBlock();
    }
}

- (IBAction)disagreeProtocolAction:(id)sender {
    if (self.agreeBlock) {
        self.agreeBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
