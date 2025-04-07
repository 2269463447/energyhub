//
//  EHActivityItemCell.m
//  EnergyHub
//
//  Created by gaojuyan on 2024/6/9.
//  Copyright © 2024 EnergyHub. All rights reserved.
//

#import "EHActivityItemCell.h"
#import "UIImageView+LoadImage.h"
#import <EnergyHub-Swift.h>

@interface EHActivityItemCell()

@property (weak, nonatomic) IBOutlet UIImageView *sloganImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end

@implementation EHActivityItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setItemData:(EHActivityItem *) itemData {
    _itemData = itemData;
    NSURL *imageURL = [NSURL URLWithString:itemData.url];
    [self.sloganImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.sloganImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.nameLabel.height = 0;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    self.nameLabel.text = itemData.activityName;
    self.dateLabel.text = itemData.date;
    self.numberLabel.text = [NSString stringWithFormat:@"已报名：%@", itemData.count];
    EHThemeView *themeView = [[EHThemeView alloc] initWithType:itemData.theme];
    [_stackView addArrangedSubview:themeView];
    for(int i=0;i<itemData.tags.count;i++){
        EHTagView *tagView = [[EHTagView alloc] initWithType:itemData.tags[i].integerValue];
        [_stackView addArrangedSubview:tagView];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        // 设置高亮效果
        self.customView.backgroundColor = EHMainColor;  // 设置高亮背景颜色
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.customView.backgroundColor = [UIColor whiteColor];  // 恢复原样
        });
    } else {
        // 恢复原样
//        self.customView.backgroundColor = [UIColor whiteColor];  // 恢复原背景颜色
    }
}



- (void)drawRect:(CGRect)rect {
    self.contentView.backgroundColor = [UIColor clearColor];
}

+ (NSString *)cellIdentifier {
    
    return NSStringFromClass(self);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.customView.backgroundColor = EHMainColor;
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    self.customView.backgroundColor = [UIColor whiteColor];
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.customView.backgroundColor = [UIColor whiteColor];
}

@end
