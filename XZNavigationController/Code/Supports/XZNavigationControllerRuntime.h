//
//  XZNavigationControllerRuntime.h
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/20.
//

#import <UIKit/UIKit.h>

// 在 Swift 环境中，
// ```swift
// @objc func foobar() {
//     foobar()
// }
// ```
// 虽然标记了 @objc 但是 `foobar()` 的调用似乎并不是 OC 消息派发，因为方法交换还是会导致死循环。
// 所以用于方法交换的方法，需要在 OC 环境中定义。
//
// 由于 [super message:YES] 在编译时，转换成的是：
// struct objc_super super = { self, objc_getClass("FooBar") }
// objc_msgSendSuper2(&super, @selector(message:), YES)
// 这导致将方法复制到其它类上时，super 指向的依然是原始定义类的父类。
//
// 然而纯 Swift 中没有 objc_msgSendSuper 函数，下面是一种方法，但是编译无法通过，原因位置。
// ```swift
// let dll = dlopen(nil, RTLD_LAZY)
// let msgSendSuper = dlsym(dll, "objc_msgSendSuper");
//
// func callSuperVoid(for object: NSObject, selector: Selector, value1: Bool) {
//     let _object     = Unmanaged<AnyObject>.passUnretained(object)
//     let objectSuper = objc_super(receiver: _object, super_class: class_getSuperclass(object_getClass(object))!);
//     withUnsafePointer(to: objectSuper) { _objectSuper in
//         unsafeBitCast(msgSendSuper, to: (@convention(c) (UnsafePointer<objc_super>, Selector, Bool) -> Void ).self)(_objectSuper, selector,  value1)
//     }
// }
// ```
// 所以需要在 OC 环境下，将调用 super 的操作定义，供 SWift 环境使用。


NS_ASSUME_NONNULL_BEGIN

@interface XZNavigationControllerRuntimeController: UINavigationController
- (void)__xz_override_viewWillAppear:(BOOL)animated;
- (void)__xz_exchange_viewWillAppear:(BOOL)animated;

- (void)__xz_override_viewDidAppear:(BOOL)animated;
- (void)__xz_exchange_viewDidAppear:(BOOL)animated;

- (void)__xz_override_pushViewController:(UIViewController *)viewController animated:(BOOL)animated NS_SWIFT_NAME(__xz_override_pushViewController(_:animated:));
- (void)__xz_exchange_pushViewController:(UIViewController *)viewController animated:(BOOL)animated NS_SWIFT_NAME(__xz_exchange_pushViewController(_:animated:));

- (void)__xz_override_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated;
- (void)__xz_exchange_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated;

- (UIViewController *)__xz_override_popViewControllerAnimated:(BOOL)animated;
- (UIViewController *)__xz_exchange_popViewControllerAnimated:(BOOL)animated;

- (NSArray<__kindof UIViewController *> *)__xz_override_popToViewController:(UIViewController *)vc animated:(BOOL)animated NS_SWIFT_NAME(__xz_override_popToViewController(_:animated:));
- (NSArray<__kindof UIViewController *> *)__xz_exchange_popToViewController:(UIViewController *)vc animated:(BOOL)animated NS_SWIFT_NAME(__xz_exchange_popToViewController(_:animated:));

- (NSArray<__kindof UIViewController *> *)__xz_override_popToRootViewControllerAnimated:(BOOL)animated;
- (NSArray<__kindof UIViewController *> *)__xz_exchange_popToRootViewControllerAnimated:(BOOL)animated;
@end

@interface XZNavigationControllerFreezableTabBar : UITabBar
- (CGRect)__xz_bounds;
- (void)__xz_setBounds:(CGRect)bounds;
- (CGRect)__xz_frame;
- (void)__xz_setFrame:(CGRect)frame;
- (BOOL)__xz_isHidden;
- (void)__xz_setHidden:(BOOL)hidden;
@end

@interface UINavigationBar (XZNavigationController)
/// 设置导航条的隐藏状态。
/// - Note: 调用此方法，不会将状态同步给已绑定自定义导航条。
/// - Note: 此方法仅对已开启自定义导航条的原生导航条生效，否则此方法不执行任何操作。
/// - Parameter isHidden: 是否隐藏。
- (void)__xz_setHidden:(BOOL)isHidden NS_SWIFT_NAME(setHidden(_:));
/// 设置导航条的半透明状态。
/// - Note: 调用此方法，不会将状态同步给已绑定自定义导航条。
/// - Note: 此方法仅对已开启自定义导航条的原生导航条生效，否则此方法不执行任何操作。
/// - Parameter isTranslucent: 是否半透明。
- (void)__xz_setTranslucent:(BOOL)isTranslucent NS_SWIFT_NAME(setTranslucent(_:));
/// 设置能否显示大标题模式。
/// - Note: 调用此方法，不会将状态同步给已绑定自定义导航条。
/// - Note: 此方法仅对已开启自定义导航条的原生导航条生效，否则此方法不执行任何操作。
/// - Parameter prefersLargeTitles: 能否展示大标题。
- (void)__xz_setPrefersLargeTitles:(BOOL)prefersLargeTitles NS_SWIFT_NAME(setPrefersLargeTitles(_:));
@end

@interface XZNavigationControllerCustomizableNavigationBar : UINavigationBar
- (BOOL)__xz_isHidden;
- (BOOL)__xz_isTranslucent;
- (BOOL)__xz_prefersLargeTitles;

- (void)__xz_layoutSubviews;
- (void)__xz_addSubview:(UIView *)view;
- (void)__xz_bringSubviewToFront:(UIView *)view;
- (void)__xz_sendSubviewToBack:(UIView *)view;
- (void)__xz_insertSubview:(UIView *)view atIndex:(NSInteger)index;
- (void)__xz_insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;
- (void)__xz_insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;
@end

NS_ASSUME_NONNULL_END
