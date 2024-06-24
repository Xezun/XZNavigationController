//
//  XZNavigationControllerCustomizableNavigationBar.m
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/24.
//

#import "XZNavigationControllerCustomizableNavigationBar.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation XZNavigationControllerCustomizableNavigationBar

- (BOOL)__xz_navc_isCustomizable {
    return YES;
}

- (BOOL)__xz_navc_isHidden {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    return ((BOOL (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(isHidden));
}

- (void)__xz_navc_setHidden:(BOOL)isHidden {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(setHidden:), isHidden);
}

- (BOOL)__xz_navc_isTranslucent {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    return ((BOOL (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(isTranslucent));
}

- (void)__xz_navc_setTranslucent:(BOOL)isTranslucent {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(setTranslucent:), isTranslucent);
}

- (BOOL)__xz_navc_prefersLargeTitles {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    return ((BOOL (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(prefersLargeTitles));
}

- (void)__xz_navc_setPrefersLargeTitles:(BOOL)prefersLargeTitles {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&_super, @selector(setPrefersLargeTitles:), prefersLargeTitles);
}


- (void)__xz_navc_layoutSubviews {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL))objc_msgSendSuper)(&_super, @selector(layoutSubviews));
}

- (void)__xz_navc_addSubview:(UIView *)view {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&_super, @selector(addSubview:), view);
}

- (void)__xz_navc_bringSubviewToFront:(UIView *)view {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&_super, @selector(bringSubviewToFront:), view);
}

- (void)__xz_navc_sendSubviewToBack:(UIView *)view {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&_super, @selector(sendSubviewToBack:), view);
}

- (void)__xz_navc_insertSubview:(UIView *)view atIndex:(NSInteger)index {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id, NSInteger))objc_msgSendSuper)(&_super, @selector(insertSubview:atIndex:), view, index);
}

- (void)__xz_navc_insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id, id))objc_msgSendSuper)(&_super, @selector(insertSubview:aboveSubview:), view, siblingSubview);
}

- (void)__xz_navc_insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview {
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, id, id))objc_msgSendSuper)(&_super, @selector(insertSubview:belowSubview:), view, siblingSubview);
}

@end
