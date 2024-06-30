//
//  XZNavigationControllerRuntime.h
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/20.
//

#import <XZNavigationController/XZNavigationControllerDefines.h>

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
//         unsafeBitCast(msgSendSuper, to: (
//             @convention(c) (UnsafePointer<objc_super>, Selector, Bool) -> Void
//         ).self)(_objectSuper, selector,  value1)
//     }
// }
// ```
// 所以需要在 OC 环境下，将调用 super 的操作定义，供 SWift 环境使用。


NS_ASSUME_NONNULL_BEGIN

/// 为运行时提供方法源，不可使用。
XZ_NAVC_PRIVATE_CLASS @interface XZNavigationControllerRuntime: UINavigationController
+ (instancetype)alloc NS_UNAVAILABLE;
+ (instancetype)allocWithZone:(struct _NSZone *)zone NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController NS_UNAVAILABLE;
- (instancetype)initWithNavigationBarClass:(nullable Class)navigationBarClass toolbarClass:(nullable Class)toolbarClass NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (void)__xz_navc_override_viewWillAppear:(BOOL)animated;
- (void)__xz_navc_exchange_viewWillAppear:(BOOL)animated;

- (void)__xz_navc_override_viewDidAppear:(BOOL)animated;
- (void)__xz_navc_exchange_viewDidAppear:(BOOL)animated;

- (void)__xz_navc_override_pushViewController:(UIViewController *)viewController animated:(BOOL)animated NS_SWIFT_NAME(__xz_navc_override_pushViewController(_:animated:));
- (void)__xz_navc_exchange_pushViewController:(UIViewController *)viewController animated:(BOOL)animated NS_SWIFT_NAME(__xz_navc_exchange_pushViewController(_:animated:));

- (void)__xz_navc_override_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated;
- (void)__xz_navc_exchange_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated;

- (UIViewController *)__xz_navc_override_popViewControllerAnimated:(BOOL)animated;
- (UIViewController *)__xz_navc_exchange_popViewControllerAnimated:(BOOL)animated;

- (NSArray<__kindof UIViewController *> *)__xz_navc_override_popToViewController:(UIViewController *)vc animated:(BOOL)animated NS_SWIFT_NAME(__xz_navc_override_popToViewController(_:animated:));
- (NSArray<__kindof UIViewController *> *)__xz_navc_exchange_popToViewController:(UIViewController *)vc animated:(BOOL)animated NS_SWIFT_NAME(__xz_navc_exchange_popToViewController(_:animated:));

- (NSArray<__kindof UIViewController *> *)__xz_navc_override_popToRootViewControllerAnimated:(BOOL)animated;
- (NSArray<__kindof UIViewController *> *)__xz_navc_exchange_popToRootViewControllerAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
