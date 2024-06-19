//
//  XZNavigationController.m
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/20.
//

#import "XZNavigationController.h"
#import <XZNavigationController/XZNavigationController-Swift.h>

@implementation UINavigationController (XZNavigationController)

- (void)__xz_override_viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UINavigationController __xz_viewController:self viewWillAppear:animated];
}

- (void)__xz_exchange_viewWillAppear:(BOOL)animated {
    [self __xz_exchange_viewWillAppear:animated];
    [UINavigationController __xz_viewController:self viewWillAppear:animated];
}

- (void)__xz_exchange_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [UINavigationController __xz_handleViewWillAppearForViewController:viewController];
    
    self.navigationBar.xz_navigationBar = nil;
    [self __xz_exchange_pushViewController:viewController animated:animated];
}

- (void)__xz_exchange_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated {
    for (UIViewController *viewController in viewControllers) {
        [UINavigationController __xz_handleViewWillAppearForViewController:viewController];
    }
    self.navigationBar.xz_navigationBar = nil;
    [self __xz_exchange_setViewControllers:viewControllers animated:animated];
}

@end


