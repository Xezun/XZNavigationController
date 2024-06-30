//
//  UINavigationBar.h
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/24.
//

#import <XZNavigationController/XZNavigationControllerDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (XZNavigationController)
/// 设置导航条的隐藏状态。
/// - Note: 调用此方法，不会将状态同步给已绑定自定义导航条。
/// - Note: 此方法仅对已开启自定义导航条的原生导航条生效，否则此方法不执行任何操作。
/// - Parameter isHidden: 是否隐藏。
- (void)__xz_navc_setHidden:(BOOL)isHidden NS_SWIFT_NAME(setHidden(_:)) XZ_NAVC_PRIVATE_METHOD;
/// 设置导航条的半透明状态。
/// - Note: 调用此方法，不会将状态同步给已绑定自定义导航条。
/// - Note: 此方法仅对已开启自定义导航条的原生导航条生效，否则此方法不执行任何操作。
/// - Parameter isTranslucent: 是否半透明。
- (void)__xz_navc_setTranslucent:(BOOL)isTranslucent NS_SWIFT_NAME(setTranslucent(_:)) XZ_NAVC_PRIVATE_METHOD;
/// 设置能否显示大标题模式。
/// - Note: 调用此方法，不会将状态同步给已绑定自定义导航条。
/// - Note: 此方法仅对已开启自定义导航条的原生导航条生效，否则此方法不执行任何操作。
/// - Parameter prefersLargeTitles: 能否展示大标题。
- (void)__xz_navc_setPrefersLargeTitles:(BOOL)prefersLargeTitles NS_SWIFT_NAME(setPrefersLargeTitles(_:)) XZ_NAVC_PRIVATE_METHOD;
/// 原生导航条返回 NO 不支持定义。
/// - Note: 当导航条开启自定义后，此属性会返回 YES 值。
- (BOOL)__xz_navc_isCustomizable XZ_NAVC_PRIVATE_METHOD;
@end

NS_ASSUME_NONNULL_END
