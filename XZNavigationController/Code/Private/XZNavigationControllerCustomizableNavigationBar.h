//
//  XZNavigationControllerCustomizableNavigationBar.h
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 为运行时提供方法源，不可使用。
@interface XZNavigationControllerCustomizableNavigationBar : UINavigationBar
+ (instancetype)alloc NS_UNAVAILABLE;
+ (instancetype)allocWithZone:(struct _NSZone *)zone NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (BOOL)__xz_navc_isHidden;
- (BOOL)__xz_navc_isTranslucent;
- (BOOL)__xz_navc_prefersLargeTitles;

- (void)__xz_navc_layoutSubviews;
- (void)__xz_navc_addSubview:(UIView *)view;
- (void)__xz_navc_bringSubviewToFront:(UIView *)view;
- (void)__xz_navc_sendSubviewToBack:(UIView *)view;
- (void)__xz_navc_insertSubview:(UIView *)view atIndex:(NSInteger)index;
- (void)__xz_navc_insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;
- (void)__xz_navc_insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;
@end

NS_ASSUME_NONNULL_END
