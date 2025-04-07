//
//  EHAreaCell.m
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/3/23.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

#import "EHAreaCell.h"
#import "Masonry.h"

@implementation EHAreaCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    UIView *selectedBackground = [UIView new];
    self.backgroundColor = [UIColor whiteColor];
    selectedBackground.backgroundColor = [UIColor colorWithHexString:@"#FFFCFA"];
    self.selectedBackgroundView = selectedBackground;
    
    [self setUI];
    
    return self;
}


- (void) setUI {
    self.backgroundColor = [UIColor clearColor];
    self.areaLabel = [[UILabel alloc] init];
    self.areaLabel.textColor = [UIColor colorWithHexString:@"#323233"];
    self.areaLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    
    [self addSubview:self.areaLabel];
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.areaLabel.textColor = [UIColor colorWithHexString:@"#FF8F21"];
    }else {
        self.areaLabel.textColor = [UIColor colorWithHexString:@"#323233"];
    }
    
    // Configure the view for the selected state
}

@end
