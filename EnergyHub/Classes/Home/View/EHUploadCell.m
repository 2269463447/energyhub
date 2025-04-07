//
//  EHUploadCell.m
//  EnergyHub
//
//  Created by fanzhou on 2017/9/10.
//  Copyright © 2017年 EnergyHub. All rights reserved.
//

#import "EHUploadCell.h"

@interface EHUploadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation EHUploadCell

- (void)setImageData:(NSData *)imageData {
    _imageData = imageData;
    self.imageView.image = [UIImage imageWithData:imageData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
