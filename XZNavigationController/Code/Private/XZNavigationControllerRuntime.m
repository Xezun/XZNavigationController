//
//  XZNavigationControllerRuntime.m
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/20.
//

#import "XZNavigationControllerRuntime.h"
// 由于 Swift.h 中有它俩的类目，需引入
#import "XZNavigationControllerFreezableTabBar.h"
#import "XZNavigationControllerCustomizableNavigationBar.h"
#import <XZNavigationController/XZNavigationController-Swift.h>

@implementation XZNavigationControllerRuntime

- (void)__xz_navc_override_viewWillAppear:(BOOL)animated {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(viewWillAppear:), animated);
    // 进入或退出转场动画的前，更新导航条状态
    [XZNavigationControllerRuntime __xz_navc_viewController:self viewWillAppear:animated];
}

- (void)__xz_navc_exchange_viewWillAppear:(BOOL)animated {
    [self __xz_navc_exchange_viewWillAppear:animated];
    [XZNavigationControllerRuntime __xz_navc_viewController:self viewWillAppear:animated];
}

- (void)__xz_navc_override_viewDidAppear:(BOOL)animated {
    [XZNavigationControllerRuntime __xz_navc_viewController:self viewDidAppear:animated];
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(viewDidAppear:), animated);
}

- (void)__xz_navc_exchange_viewDidAppear:(BOOL)animated {
    // 当页面 viewDidAppear 调用时，自定义导航条已与原生导航条绑定。
    [XZNavigationControllerRuntime __xz_navc_viewController:self viewDidAppear:animated];
    [self __xz_navc_exchange_viewDidAppear:animated];
}



- (void)__xz_navc_override_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [XZNavigationControllerRuntime __xz_navc_navigationController:self customizeViewController:viewController];
    
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id, BOOL))objc_msgSendSuper)(&_super, @selector(pushViewController:animated:), viewController, animated);
    // 导航控制器，同一控制器不能重复 push 不论栈顶还是栈中，否则崩溃，所以这里不需要判断。
    // 在 push 方法调用的过程中，目标控制器没有任何生命周期函数被调用，所以可以在 super.push 之后再执行转场准备工作。
    [XZNavigationControllerRuntime __xz_navc_prepareForNavigationTransition:self];
}

- (void)__xz_navc_exchange_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [XZNavigationControllerRuntime __xz_navc_navigationController:self customizeViewController:viewController];
    [self __xz_navc_exchange_pushViewController:viewController animated:animated];
    [XZNavigationControllerRuntime __xz_navc_prepareForNavigationTransition:self];
}



- (void)__xz_navc_override_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated {
    for (UIViewController *viewController in viewControllers) {
        [XZNavigationControllerRuntime __xz_navc_navigationController:self customizeViewController:viewController];
    }
    
    UIViewController * const topViewController = self.topViewController;
    
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id, BOOL))objc_msgSendSuper)(&_super, @selector(setViewControllers:animated:), viewControllers, animated);
    
    if (topViewController != viewControllers.lastObject) {
        [XZNavigationControllerRuntime __xz_navc_prepareForNavigationTransition:self];
    }
}

- (void)__xz_navc_exchange_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated {
    for (UIViewController *viewController in viewControllers) {
        [XZNavigationControllerRuntime __xz_navc_navigationController:self customizeViewController:viewController];
    }
    
    UIViewController * const topViewController = self.topViewController;
    
    [self __xz_navc_exchange_setViewControllers:viewControllers animated:animated];
    
    if (topViewController != viewControllers.lastObject) {
        [XZNavigationControllerRuntime __xz_navc_prepareForNavigationTransition:self];
    }
}



- (UIViewController *)__xz_navc_override_popViewControllerAnimated:(BOOL)animated {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    UIViewController *viewController = ((id (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(popViewControllerAnimated:), animated);
    if (viewController != nil) {
        [XZNavigationControllerRuntime __xz_navc_prepareForNavigationTransition:self];
    }
    return viewController;
}

- (UIViewController *)__xz_navc_exchange_popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [self __xz_navc_exchange_popViewControllerAnimated:animated];
    if (viewController != nil) {
        [XZNavigationControllerRuntime __xz_navc_prepareForNavigationTransition:self];
    }
    return viewController;
}



- (NSArray<__kindof UIViewController *> *)__xz_navc_override_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    NSArray *viewControllers = ((id (*)(struct objc_super *, SEL, id, BOOL))objc_msgSendSuper)(&_super, @selector(popToViewController:animated:), viewController, animated);
    if (viewControllers.count > 0) {
        [XZNavigationControllerRuntime __xz_navc_prepareForNavigationTransition:self];
    }
    return viewControllers;
}

- (NSArray<__kindof UIViewController *> *)__xz_navc_exchange_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *viewControllers = [self __xz_navc_exchange_popToViewController:viewController animated:animated];
    if (viewControllers.count > 0) {
        [XZNavigationControllerRuntime __xz_navc_prepareForNavigationTransition:self];
    }
    return viewControllers;
}



- (NSArray<__kindof UIViewController *> *)__xz_navc_override_popToRootViewControllerAnimated:(BOOL)animated {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    NSArray *viewControllers = ((id (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(popToRootViewControllerAnimated:), animated);
    if (viewControllers.count > 0) {
        [XZNavigationControllerRuntime __xz_navc_prepareForNavigationTransition:self];
    }
    return viewControllers;
}

- (NSArray<__kindof UIViewController *> *)__xz_navc_exchange_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *viewControllers = [self __xz_navc_exchange_popToRootViewControllerAnimated:animated];
    if (viewControllers.count > 0) {
        [XZNavigationControllerRuntime __xz_navc_prepareForNavigationTransition:self];
    }
    return viewControllers;
}

@end
