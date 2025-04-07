//
//  EHActivityTopView.h
//  diceng
//
//  Created by 赵贤斌 on 2025/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EHActivityTopViewDelegate <NSObject>

@optional
- (void)didExpandSelection;  // 选择展开
- (void)didCloseSelection;   // 选择关闭
- (void)didSelectAreaWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;  // 地区选择具体地区
- (void)didSelectActivity:(NSString *)activity;

- (void)clickManageView;
- (void)clickReleaseView;

@end

@interface EHActivityTopView : UIView

@property (nonatomic, weak) id<EHActivityTopViewDelegate> delegate;  // 协议代理

@property (nonatomic, copy) void (^onLocationSelected)(NSString *province, NSString *city, NSString *district);
@property (nonatomic, strong) UIView *whiteView;


@end

NS_ASSUME_NONNULL_END
