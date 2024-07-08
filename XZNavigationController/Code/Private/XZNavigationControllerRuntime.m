//
//  XZNavigationControllerRuntime.m
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/20.
//

#import "XZNavigationControllerRuntime.h"
// 由于 Swift.h 中有它俩的类目，需引入
#import <XZNavigationController/XZNavigationController-Swift.h>

#pragma mark - UINavigationController

void xz_navc_msgSendSuper_setDelegate(id receiver, id _Nullable delegate) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&_super, @selector(setDelegate:), delegate);
}

void xz_navc_msgSendExchange_setDelegate(id receiver, SEL selector, id _Nullable delegate) {
    ((void (*)(id, SEL, id))objc_msgSend)(receiver, selector, delegate);
}



void xz_navc_msgSendSuper_pushViewController(UINavigationController *receiver, UIViewController *viewController, BOOL animated) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, id, BOOL))objc_msgSendSuper)(&_super, @selector(pushViewController:animated:), viewController, animated);
}

void xz_navc_msgSendExchange_pushViewController(UINavigationController *receiver, SEL selector, UIViewController *viewController, BOOL animated) {
    ((void (*)(UINavigationController *, SEL, id, BOOL))objc_msgSend)(receiver, selector, viewController, animated);
}

void xz_navc_msgSendSuper_setViewControllers(UINavigationController *receiver, NSArray<__kindof UIViewController *> *viewControllers, BOOL animated) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, id, BOOL))objc_msgSendSuper)(&_super, @selector(setViewControllers:animated:), viewControllers, animated);
}

void xz_navc_msgSendExchange_setViewControllers(UINavigationController *receiver, SEL selector, NSArray<__kindof UIViewController *> *viewControllers, BOOL animated) {
    ((void (*)(UINavigationController *, SEL, id, BOOL))objc_msgSend)(receiver, selector, viewControllers, animated);
}


UIViewController * _Nullable xz_navc_msgSendSuper_popViewController(UINavigationController *receiver, BOOL animated) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    return ((id (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(popViewControllerAnimated:), animated);
}

UIViewController * _Nullable xz_navc_msgSendExchange_popViewController(UINavigationController *receiver, SEL selector, BOOL animated) {
    return ((id (*)(UINavigationController *, SEL, BOOL))objc_msgSend)(receiver, selector, animated);
}

NSArray<__kindof UIViewController *> * _Nullable xz_navc_msgSendSuper_popToViewController(UINavigationController *receiver, UIViewController *viewController, BOOL animated) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    return ((id (*)(struct objc_super *, SEL, id, BOOL))objc_msgSendSuper)(&_super, @selector(popToViewController:animated:), viewController, animated);
}

NSArray<__kindof UIViewController *> * _Nullable xz_navc_msgSendExchange_popToViewController(UINavigationController *receiver, SEL selector, UIViewController *viewController, BOOL animated) {
    return ((id (*)(id, SEL, id, BOOL))objc_msgSend)(receiver, selector, viewController, animated);
}

NSArray<__kindof UIViewController *> * _Nullable xz_navc_msgSendSuper_popToRootViewController(UINavigationController *receiver, BOOL animated) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    return ((id (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(popToRootViewControllerAnimated:), animated);
}

NSArray<__kindof UIViewController *> * _Nullable xz_navc_msgSendExchange_popToRootViewController(UINavigationController *receiver, SEL selector, BOOL animated) {
    return ((id (*)(id, SEL, BOOL))objc_msgSend)(receiver, selector, animated);
}

#pragma mark - UIViewController

void xz_navc_msgSendSuper_viewWillAppear(UIViewController *receiver, BOOL animated) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(viewWillAppear:), animated);
}

void xz_navc_msgSendExchange_viewWillAppear(UIViewController *receiver, SEL selector, BOOL animated) {
    ((void (*)(UIViewController *, SEL, BOOL))objc_msgSend)(receiver, selector, animated);
}

void xz_navc_msgSendSuper_viewDidAppear(UIViewController *receiver, BOOL animated) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(viewDidAppear:), animated);
}

void xz_navc_msgSendExchange_viewDidAppear(UIViewController *receiver, SEL selector, BOOL animated) {
    ((void (*)(UIViewController *, SEL, BOOL))objc_msgSend)(receiver, selector, animated);
}

#pragma mark - UINavigationControllerDelegate

typedef id<UIViewControllerAnimatedTransitioning> (*Method1Type)(id, SEL, UINavigationController *, UINavigationControllerOperation, UIViewController *, UIViewController *);
typedef id<UIViewControllerAnimatedTransitioning> (*Method1SuperType)(struct objc_super *, SEL, UINavigationController *, UINavigationControllerOperation, UIViewController *, UIViewController *);
typedef id<UIViewControllerInteractiveTransitioning> (*Method2Type)(id, SEL, UINavigationController *, id<UIViewControllerAnimatedTransitioning>);
typedef id<UIViewControllerInteractiveTransitioning> (*Method2SuperType)(struct objc_super *, SEL, UINavigationController *, id<UIViewControllerAnimatedTransitioning>);

id<UIViewControllerAnimatedTransitioning> _Nullable xz_navc_msgSendSuper_animationControllerForOperation(id<UINavigationControllerDelegate> receiver, UINavigationController *navigationController, UINavigationControllerOperation operation, UIViewController *fromVC, UIViewController *toVC) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    SEL const selector = @selector(navigationController:animationControllerForOperation:fromViewController:toViewController:);
    return ((Method1SuperType)objc_msgSendSuper)(&_super, selector, navigationController, operation, fromVC, toVC);;
}

id<UIViewControllerAnimatedTransitioning> _Nullable xz_navc_msgSendExchange_animationControllerForOperation(id<UINavigationControllerDelegate> receiver, SEL selector, UINavigationController *navigationController, UINavigationControllerOperation operation, UIViewController *fromVC, UIViewController *toVC) {
    return ((Method1Type)objc_msgSend)(receiver, selector, navigationController, operation, fromVC, toVC);
}

id<UIViewControllerInteractiveTransitioning> _Nullable xz_navc_msgSendSuper_interactionControllerForAnimationController(id<UINavigationControllerDelegate> receiver, UINavigationController *navigationController, id<UIViewControllerAnimatedTransitioning> animationController) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    SEL const selector = @selector(navigationController:interactionControllerForAnimationController:);
    return ((Method2SuperType)objc_msgSendSuper)(&_super, selector, navigationController, animationController);
}

id<UIViewControllerInteractiveTransitioning> _Nullable xz_navc_msgSendExchange_interactionControllerForAnimationController(id<UINavigationControllerDelegate> receiver, SEL selector, UINavigationController *navigationController, id<UIViewControllerAnimatedTransitioning> animationController) {
    return ((Method2Type)objc_msgSend)(receiver, selector, navigationController, animationController);
}


#pragma mark - UITabBar

CGRect xz_navc_msgSendSuper_bounds(UIView *receiver) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    return ((CGRect (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(bounds));
}

void xz_navc_msgSendSuper_setBounds(UIView *receiver, CGRect bounds) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, CGRect))objc_msgSendSuper)(&_super, @selector(setBounds:), bounds);
}

CGRect xz_navc_msgSendSuper_frame(UIView *receiver) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    return ((CGRect (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(frame));
}

void xz_navc_msgSendSuper_setFrame(UIView *receiver, CGRect frame) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, CGRect))objc_msgSendSuper)(&_super, @selector(setFrame:), frame);
}

BOOL xz_navc_msgSendSuper_isHidden(UIView *receiver) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    return ((BOOL (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(isHidden));
}

void xz_navc_msgSendSuper_setHidden(UIView *receiver, BOOL isHidden) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(setHidden:), isHidden);
}

#pragma mark - UINavigationBar


BOOL xz_navc_msgSendSuper_isTranslucent(UIView *receiver) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    return ((BOOL (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(isTranslucent));
}

void xz_navc_msgSendSuper_setTranslucent(UIView *receiver, BOOL isTranslucent) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(setTranslucent:), isTranslucent);

}

BOOL xz_navc_msgSendSuper_prefersLargeTitles(UIView *receiver) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    return ((BOOL (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(prefersLargeTitles));
}

void xz_navc_msgSendSuper_setPrefersLargeTitles(UIView *receiver, BOOL prefersLargeTitles) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(setPrefersLargeTitles:), prefersLargeTitles);
}

void xz_navc_msgSendSuper_layoutSubviews(UIView *receiver) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(layoutSubviews));
}

void xz_navc_msgSendSuper_addSubview(UIView *receiver, UIView *view) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&_super, @selector(addSubview:), view);
}

void xz_navc_msgSendSuper_bringSubviewToFront(UIView *receiver, UIView *view) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&_super, @selector(bringSubviewToFront:), view);
}

void xz_navc_msgSendSuper_sendSubviewToBack(UIView *receiver, UIView *view) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&_super, @selector(sendSubviewToBack:), view);
}

void xz_navc_msgSendSuper_insertSubviewAtIndex(UIView *receiver, UIView *view, NSInteger index) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, id, NSInteger))objc_msgSendSuper)(&_super, @selector(insertSubview:atIndex:), view, index);
}

void xz_navc_msgSendSuper_insertSubviewAboveSubview(UIView *receiver, UIView *view, UIView *siblingSubview) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, id, id))objc_msgSendSuper)(&_super, @selector(insertSubview:aboveSubview:), view, siblingSubview);
}

void xz_navc_msgSendSuper_insertSubviewBelowSubview(UIView *receiver, UIView *view, UIView *siblingSubview) {
    struct objc_super _super = {
        .receiver = receiver,
        .super_class = class_getSuperclass(object_getClass(receiver))
    };
    ((void (*)(struct objc_super *, SEL, id, id))objc_msgSendSuper)(&_super, @selector(insertSubview:belowSubview:), view, siblingSubview);
}
