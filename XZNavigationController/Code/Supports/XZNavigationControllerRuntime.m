//
//  XZNavigationControllerRuntime.m
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/20.
//

#import "XZNavigationControllerRuntime.h"
#import <XZNavigationController/XZNavigationController-Swift.h>

@implementation XZNavigationControllerRuntimeController

- (void)__xz_override_viewWillAppear:(BOOL)animated {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(viewWillAppear:), animated);
    // 进入或退出转场动画的前，更新导航条状态
    [XZNavigationControllerRuntimeController __xz_viewController:self viewWillAppear:animated];
}

- (void)__xz_exchange_viewWillAppear:(BOOL)animated {
    [self __xz_exchange_viewWillAppear:animated];
    [XZNavigationControllerRuntimeController __xz_viewController:self viewWillAppear:animated];
}

- (void)__xz_override_viewDidAppear:(BOOL)animated {
    [XZNavigationControllerRuntimeController __xz_viewController:self viewDidAppear:animated];
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(viewDidAppear:), animated);
}

- (void)__xz_exchange_viewDidAppear:(BOOL)animated {
    // 当页面 viewDidAppear 调用时，自定义导航条已与原生导航条绑定。
    [XZNavigationControllerRuntimeController __xz_viewController:self viewDidAppear:animated];
    [self __xz_exchange_viewDidAppear:animated];
}



- (void)__xz_override_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [XZNavigationControllerRuntimeController __xz_customizeViewController:viewController];
    
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id, BOOL))objc_msgSendSuper)(&_super, @selector(pushViewController:animated:), viewController, animated);
    // 导航控制器，同一控制器不能重复 push 不论栈顶还是栈中，否则崩溃，所以这里不需要判断。
    [XZNavigationControllerRuntimeController __xz_prepareForNavigationTransition:self];
}

- (void)__xz_exchange_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [XZNavigationControllerRuntimeController __xz_customizeViewController:viewController];
    [self __xz_exchange_pushViewController:viewController animated:animated];
    [XZNavigationControllerRuntimeController __xz_prepareForNavigationTransition:self];
}



- (void)__xz_override_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated {
    for (UIViewController *viewController in viewControllers) {
        [XZNavigationControllerRuntimeController __xz_customizeViewController:viewController];
    }
    
    UIViewController * const topViewController = self.topViewController;
    
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id, BOOL))objc_msgSendSuper)(&_super, @selector(setViewControllers:animated:), viewControllers, animated);
    
    if (topViewController != viewControllers.lastObject) {
        [XZNavigationControllerRuntimeController __xz_prepareForNavigationTransition:self];
    }
}

- (void)__xz_exchange_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated {
    for (UIViewController *viewController in viewControllers) {
        [XZNavigationControllerRuntimeController __xz_customizeViewController:viewController];
    }
    
    UIViewController * const topViewController = self.topViewController;
    
    [self __xz_exchange_setViewControllers:viewControllers animated:animated];
    
    if (topViewController != viewControllers.lastObject) {
        [XZNavigationControllerRuntimeController __xz_prepareForNavigationTransition:self];
    }
}



- (UIViewController *)__xz_override_popViewControllerAnimated:(BOOL)animated {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    UIViewController *viewController = ((id (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(popViewControllerAnimated:), animated);
    if (viewController != nil) {
        [XZNavigationControllerRuntimeController __xz_prepareForNavigationTransition:self];
    }
    return viewController;
}

- (UIViewController *)__xz_exchange_popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [self __xz_exchange_popViewControllerAnimated:animated];
    if (viewController != nil) {
        [XZNavigationControllerRuntimeController __xz_prepareForNavigationTransition:self];
    }
    return viewController;
}



- (NSArray<__kindof UIViewController *> *)__xz_override_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    NSArray *viewControllers = ((id (*)(struct objc_super *, SEL, id, BOOL))objc_msgSendSuper)(&_super, @selector(popToViewController:animated:), viewController, animated);
    if (viewControllers.count > 0) {
        [XZNavigationControllerRuntimeController __xz_prepareForNavigationTransition:self];
    }
    return viewControllers;
}

- (NSArray<__kindof UIViewController *> *)__xz_exchange_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *viewControllers = [self __xz_exchange_popToViewController:viewController animated:animated];
    if (viewControllers.count > 0) {
        [XZNavigationControllerRuntimeController __xz_prepareForNavigationTransition:self];
    }
    return viewControllers;
}



- (NSArray<__kindof UIViewController *> *)__xz_override_popToRootViewControllerAnimated:(BOOL)animated {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    NSArray *viewControllers = ((id (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(popToRootViewControllerAnimated:), animated);
    if (viewControllers.count > 0) {
        [XZNavigationControllerRuntimeController __xz_prepareForNavigationTransition:self];
    }
    return viewControllers;
}

- (NSArray<__kindof UIViewController *> *)__xz_exchange_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *viewControllers = [self __xz_exchange_popToRootViewControllerAnimated:animated];
    if (viewControllers.count > 0) {
        [XZNavigationControllerRuntimeController __xz_prepareForNavigationTransition:self];
    }
    return viewControllers;
}

@end

@implementation XZNavigationControllerFreezableTabBar

- (CGRect)__xz_frame {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    return ((CGRect (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(frame));
}

- (void)__xz_setFrame:(CGRect)frame {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, CGRect))objc_msgSendSuper)(&_super, @selector(setFrame:), frame);
}

- (CGRect)__xz_bounds {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    return ((CGRect (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(bounds));
}

- (void)__xz_setBounds:(CGRect)bounds {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, CGRect))objc_msgSendSuper)(&_super, @selector(setBounds:), bounds);
}

- (BOOL)__xz_isHidden {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    return ((BOOL (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(isHidden));
}

- (void)__xz_setHidden:(BOOL)hidden {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(setHidden:), hidden);
}

@end


@implementation UINavigationBar (XZNavigationController)

- (void)__xz_setHidden:(BOOL)isHidden {

}

- (void)__xz_setTranslucent:(BOOL)isTranslucent {

}

- (void)__xz_setPrefersLargeTitles:(BOOL)prefersLargeTitles {

}

@end

@implementation XZNavigationControllerCustomizableNavigationBar

- (BOOL)__xz_isHidden {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    return ((BOOL (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(isHidden));
}

- (void)__xz_setHidden:(BOOL)isHidden {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(setHidden:), isHidden);
}

- (BOOL)__xz_isTranslucent {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    return ((BOOL (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(isTranslucent));
}

- (void)__xz_setTranslucent:(BOOL)isTranslucent {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(setTranslucent:), isTranslucent);
}

- (BOOL)__xz_prefersLargeTitles {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    return ((BOOL (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(prefersLargeTitles));
}

- (void)__xz_setPrefersLargeTitles:(BOOL)prefersLargeTitles {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(setPrefersLargeTitles:), prefersLargeTitles);
}


- (void)__xz_layoutSubviews {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(layoutSubviews));
}

- (void)__xz_addSubview:(UIView *)view {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&_super, @selector(addSubview:), view);
}

- (void)__xz_bringSubviewToFront:(UIView *)view {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&_super, @selector(bringSubviewToFront:), view);
}

- (void)__xz_sendSubviewToBack:(UIView *)view {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&_super, @selector(sendSubviewToBack:), view);
}

- (void)__xz_insertSubview:(UIView *)view atIndex:(NSInteger)index {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id, NSInteger))objc_msgSendSuper)(&_super, @selector(insertSubview:atIndex:), view, index);
}

- (void)__xz_insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id, id))objc_msgSendSuper)(&_super, @selector(insertSubview:aboveSubview:), view, siblingSubview);
}

- (void)__xz_insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id, id))objc_msgSendSuper)(&_super, @selector(insertSubview:belowSubview:), view, siblingSubview);
}

@end
