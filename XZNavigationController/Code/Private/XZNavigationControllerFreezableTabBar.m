//
//  XZNavigationControllerFreezableTabBar.m
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/24.
//

#import "XZNavigationControllerFreezableTabBar.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation XZNavigationControllerFreezableTabBar

- (CGRect)__xz_navc_frame {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    return ((CGRect (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(frame));
}

- (void)__xz_navc_setFrame:(CGRect)frame {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, CGRect))objc_msgSendSuper)(&_super, @selector(setFrame:), frame);
}

- (CGRect)__xz_navc_bounds {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    return ((CGRect (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(bounds));
}

- (void)__xz_navc_setBounds:(CGRect)bounds {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, CGRect))objc_msgSendSuper)(&_super, @selector(setBounds:), bounds);
}

- (BOOL)__xz_navc_isHidden {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    return ((BOOL (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(isHidden));
}

- (void)__xz_navc_setHidden:(BOOL)hidden {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(setHidden:), hidden);
}

@end
