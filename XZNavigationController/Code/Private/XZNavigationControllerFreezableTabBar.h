//
//  XZNavigationControllerFreezableTabBar.h
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 为运行时提供方法源，不可使用。
@interface XZNavigationControllerFreezableTabBar : UITabBar
+ (instancetype)alloc NS_UNAVAILABLE;
+ (instancetype)allocWithZone:(struct _NSZone *)zone NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (CGRect)__xz_navc_bounds;
- (void)__xz_navc_setBounds:(CGRect)bounds;
- (CGRect)__xz_navc_frame;
- (void)__xz_navc_setFrame:(CGRect)frame;
- (BOOL)__xz_navc_isHidden;
- (void)__xz_navc_setHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
