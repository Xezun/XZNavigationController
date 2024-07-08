//
//  XZNavigationControllerRuntime.h
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/20.
//

#import <XZNavigationController/XZNavigationControllerDefines.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - UINavigationController

FOUNDATION_EXPORT void xz_navc_msgSendSuper_setDelegate(id receiver, id _Nullable delegate)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:setDelegate:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendExchange_setDelegate(id receiver, SEL selector, id _Nullable delegate)
NS_SWIFT_NAME(xz_navc_msgSend(_:exchange:setDelegate:)) XZ_NAVC_PRIVATE_METHOD;

FOUNDATION_EXPORT void xz_navc_msgSendSuper_pushViewController(UINavigationController *receiver, UIViewController *viewController, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:pushViewController:animated:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendExchange_pushViewController(UINavigationController *receiver, SEL selector, UIViewController *viewController, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSend(_:exchange:pushViewController:animated:)) XZ_NAVC_PRIVATE_METHOD;

FOUNDATION_EXPORT void xz_navc_msgSendSuper_setViewControllers(UINavigationController *receiver, NSArray<__kindof UIViewController *> *viewControllers, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:setViewControllers:animated:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendExchange_setViewControllers(UINavigationController *receiver, SEL selector, NSArray<__kindof UIViewController *> *viewControllers, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSend(_:exchange:setViewControllers:animated:)) XZ_NAVC_PRIVATE_METHOD;

FOUNDATION_EXPORT UIViewController * _Nullable xz_navc_msgSendSuper_popViewController(UINavigationController *receiver, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:popViewControllerAnimated:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT UIViewController * _Nullable xz_navc_msgSendExchange_popViewController(UINavigationController *receiver, SEL selector, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSend(_:exchange:popViewControllerAnimated:)) XZ_NAVC_PRIVATE_METHOD;

FOUNDATION_EXPORT NSArray<__kindof UIViewController *> * _Nullable xz_navc_msgSendSuper_popToViewController(UINavigationController *receiver, UIViewController *viewController, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:popToViewController:animated:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT NSArray<__kindof UIViewController *> * _Nullable xz_navc_msgSendExchange_popToViewController(UINavigationController *receiver, SEL selector, UIViewController *viewController, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSend(_:exchange:popToViewController:animated:)) XZ_NAVC_PRIVATE_METHOD;

FOUNDATION_EXPORT NSArray<__kindof UIViewController *> * _Nullable xz_navc_msgSendSuper_popToRootViewController(UINavigationController *receiver, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:popToRootViewControllerAnimated:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT NSArray<__kindof UIViewController *> * _Nullable xz_navc_msgSendExchange_popToRootViewController(UINavigationController *receiver, SEL selector, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSend(_:exchange:popToRootViewControllerAnimated:)) XZ_NAVC_PRIVATE_METHOD;


#pragma mark - UIViewController

FOUNDATION_EXPORT void xz_navc_msgSendSuper_viewWillAppear(UIViewController *receiver, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:viewWillAppear:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendExchange_viewWillAppear(UIViewController *receiver, SEL selector, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSend(_:exchange:viewWillAppear:)) XZ_NAVC_PRIVATE_METHOD;

FOUNDATION_EXPORT void xz_navc_msgSendSuper_viewDidAppear(UIViewController *receiver, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:viewDidAppear:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendExchange_viewDidAppear(UIViewController *receiver, SEL selector, BOOL animated)
NS_SWIFT_NAME(xz_navc_msgSend(_:exchange:viewDidAppear:)) XZ_NAVC_PRIVATE_METHOD;


#pragma mark - UINavigationControllerDelegate

FOUNDATION_EXPORT id<UIViewControllerAnimatedTransitioning> _Nullable xz_navc_msgSendSuper_animationControllerForOperation(id<UINavigationControllerDelegate> receiver, UINavigationController *navigationController, UINavigationControllerOperation operation, UIViewController *fromVC, UIViewController *toVC)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:navigationController:animationControllerFor:from:to:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT id<UIViewControllerAnimatedTransitioning> _Nullable xz_navc_msgSendExchange_animationControllerForOperation(id<UINavigationControllerDelegate> receiver, SEL selector, UINavigationController *navigationController, UINavigationControllerOperation operation, UIViewController *fromVC, UIViewController *toVC)
NS_SWIFT_NAME(xz_navc_msgSend(_:exchange:navigationController:animationControllerFor:from:to:)) XZ_NAVC_PRIVATE_METHOD;

FOUNDATION_EXPORT id<UIViewControllerInteractiveTransitioning> _Nullable xz_navc_msgSendSuper_interactionControllerForAnimationController(id<UINavigationControllerDelegate> receiver, UINavigationController *navigationController, id<UIViewControllerAnimatedTransitioning> animationController)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:navigationController:interactionControllerFor:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT id<UIViewControllerInteractiveTransitioning> _Nullable xz_navc_msgSendExchange_interactionControllerForAnimationController(id<UINavigationControllerDelegate> receiver, SEL selector, UINavigationController *navigationController, id<UIViewControllerAnimatedTransitioning> animationController)
NS_SWIFT_NAME(xz_navc_msgSend(_:exchange:navigationController:interactionControllerFor:)) XZ_NAVC_PRIVATE_METHOD;


#pragma mark - UITabBar

FOUNDATION_EXPORT CGRect xz_navc_msgSendSuper_bounds(UIView *receiver)
NS_SWIFT_NAME(xz_navc_msgSendSuper(bounds:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendSuper_setBounds(UIView *receiver, CGRect bounds)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:setBounds:)) XZ_NAVC_PRIVATE_METHOD;


FOUNDATION_EXPORT CGRect xz_navc_msgSendSuper_frame(UIView *receiver)
NS_SWIFT_NAME(xz_navc_msgSendSuper(frame:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendSuper_setFrame(UIView *receiver, CGRect frame)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:setFrame:)) XZ_NAVC_PRIVATE_METHOD;


FOUNDATION_EXPORT BOOL xz_navc_msgSendSuper_isHidden(UIView *receiver)
NS_SWIFT_NAME(xz_navc_msgSendSuper(isHidden:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendSuper_setHidden(UIView *receiver, BOOL isHidden)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:setHidden:)) XZ_NAVC_PRIVATE_METHOD;


#pragma mark - UINavigationBar

FOUNDATION_EXPORT BOOL xz_navc_msgSendSuper_isTranslucent(UIView *receiver)
NS_SWIFT_NAME(xz_navc_msgSendSuper(isTranslucent:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendSuper_setTranslucent(UIView *receiver, BOOL isTranslucent)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:setTranslucent:)) XZ_NAVC_PRIVATE_METHOD;

FOUNDATION_EXPORT BOOL xz_navc_msgSendSuper_prefersLargeTitles(UIView *receiver)
NS_SWIFT_NAME(xz_navc_msgSendSuper(prefersLargeTitles:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendSuper_setPrefersLargeTitles(UIView *receiver, BOOL prefersLargeTitles)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:setPrefersLargeTitles:)) XZ_NAVC_PRIVATE_METHOD;

FOUNDATION_EXPORT void xz_navc_msgSendSuper_layoutSubviews(UIView *receiver)
NS_SWIFT_NAME(xz_navc_msgSendSuper(layoutSubviews:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendSuper_addSubview(UIView *receiver, UIView *view)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:addSubview:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendSuper_bringSubviewToFront(UIView *receiver, UIView *view)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:bringSubviewToFront:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendSuper_sendSubviewToBack(UIView *receiver, UIView *view)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:sendSubviewToBack:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendSuper_insertSubviewAtIndex(UIView *receiver, UIView *view, NSInteger index)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:insertSubview:atIndex:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendSuper_insertSubviewAboveSubview(UIView *receiver, UIView *view, UIView *siblingSubview)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:insertSubview:aboveSubview:)) XZ_NAVC_PRIVATE_METHOD;
FOUNDATION_EXPORT void xz_navc_msgSendSuper_insertSubviewBelowSubview(UIView *receiver, UIView *view, UIView *siblingSubview)
NS_SWIFT_NAME(xz_navc_msgSendSuper(_:insertSubview:belowSubview:)) XZ_NAVC_PRIVATE_METHOD;


NS_ASSUME_NONNULL_END


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
