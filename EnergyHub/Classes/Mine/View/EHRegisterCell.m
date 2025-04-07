//
//  EHRegisterCell.m
//  EnergyHub
//
//  Created by cpf on 2017/8/28.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHRegisterCell.h"

@interface EHRegisterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation EHRegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSString *placeholder = dict[@"placeholder"];
    self.imgView.image = [UIImage imageNamed:dict[@"imgName"]];
    self.contentTextField.placeholder = placeholder;
    
    if ([placeholder containsString:@"密码"]) {
        self.contentTextField.secureTextEntry = YES;
    }else{
        self.contentTextField.secureTextEntry = NO;
    }
}

@end
