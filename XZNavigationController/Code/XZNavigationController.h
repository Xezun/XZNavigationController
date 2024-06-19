//
//  XZNavigationController.h
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (XZNavigationController)
- (void)__xz_override_viewWillAppear:(BOOL)animated;
- (void)__xz_exchange_viewWillAppear:(BOOL)animated;

- (void)__xz_exchange_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)__xz_exchange_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated;
@end


NS_ASSUME_NONNULL_END
