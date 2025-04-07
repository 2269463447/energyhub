//
//  EHRecordCell.m
//  EnergyHub
//
//  Created by cpf on 2017/9/5.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHRecordCell.h"
#import "EHRecordModel.h"
#import "NSString+EHMoney.h"

@interface EHRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *datelabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation EHRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecord:(EHRecordModel *)record {
    _record = record;
    self.titleLabel.text = record.course;
    self.datelabel.text = record.time;
    
//    NSString *moeny = [NSString stringWithFormat:@"%.2f",     (record.number.floatValue * 1.3)/10.0];
    
    self.priceLabel.text = [record.number stringByAppendingString:@"U币"];
}

@end
