//
//  XZNavigationController.swift
//  XZKit
//
//  Created by Xezun on 2017/2/17.
//  Copyright © 2017年 XEZUN INC. All rights reserved.
//
// 【开发备忘】
// 为了将更新导航条的操作放在 viewWillAppear 中：
// 一、 方法交换，重写 UIViewController 基类的 viewWillAppear 方法，遇到一下问题：
//      1. 某些页面，交换后的方法不执行（猜测可能是因为Swift消息派发机制，没有把方法按 objc 消息派发问题）
//      2. 控制器重写的逻辑，在交换方法的逻辑之后运行，导致页面可能没有按照自定义导航条的配置来展示。
//      3. 重写 UIViewController 基类，影响较大。
// 二、重写 UINavigationController 的 addChildViewController 方法。
//      1. 方法不调用
// 三、监听 viewControllers 属性
//      1. KVO 触发
// 以上问题多是因为 Swift 优化了 OC 运行时代码，因此采用了使用 OC 来实现。
//
// 【已知问题一】
// 如下操作会导致自定义导航条丢失。
// ```swift
// if let navigationController = navigationController {
//    let viewControllers = navigationController.viewControllers
//    navigationController.setViewControllers([], animated: false)
//    navigationController.setViewControllers(viewControllers, animated: false)
// }
// ```
// 因为 set 操作时，XZNavigationController 认为是转场开始而移除了自定义导航条，
// 但是 UINavigationController 在处理这种情形时，认为没有转场发生，所以最终也没有 viewDidAppear 执行，
// 自定义导航条没有机会展示。
// 这说明，在 UINavigationController 中，方法 setViewControllers 实际是有延迟的。
// 如果确实有这种逻辑需求，可以延迟第二次操作，来避免这个问题。
//
// 【已知问题二】
// 在 UITabBarController 中时，tabBar 只在首页显示，如果手势跨层返回首页，那么 tabBar 没有动画转场动画，
// 即没有从场外进场的过程，而是直接显示在底部，覆盖在转场的控制器之上。不过，如果转场取消一次，再次手势返回的话，
// tabBar 却又有转场动画。
// 目前，对于 left-to-right 布局下，没有控制 tabBar 的动画效果，虽然可以开启来解决这个问题，但是觉得没有必要。
//
// 【已知问题三】
// 在使用 `-popToViewController:animated:` 进行手势跨层 pop 时，那么被 popTo 跨过的页面
// 会被导航栈移除，且手势取消了操作，导航栈也不会恢复。这 BUG 是原生的，虽然可以尝试修复，但觉得没有必要。
// 因为已经使用 `popTo` 跨层了，那说明，被跨的层，在业务逻辑中，大概率属于不可返回的页面，没有恢复的必要。
//

import UIKit
import XZDefines
import ObjectiveC

/// 为导航控制器 UINavigationController 提供 自定义全屏手势 功能和 自定义导航条 功能的协议。
///
/// 当导航控制器开启自定义功能后：
/// 1. 栈内控制器可通过协议 `XZNavigationBarCustomizable` 自定义导航条。
/// 2. 边缘返回手势默认开启，但可通过协议 `XZNavigationGestureDrivable` 控制手势导航行为，或开启全屏手势。
/// 3. 导航控制器的 `delegate` 将被设置为协议拓展的 `transitionController` 属性，如果被修改，自定义功能可能不会生效。
/// 4. 接收导航控制器原事件，请通过 `transitionController.delegate` 设置代理。
public protocol XZNavigationController: UINavigationController {

}

extension XZNavigationController {
    
    /// 开启自定义模式。
    /// - Note: 当前导航控制的 delegate 事件已被 transitionController 接管。可通过设置 transitionController 的 delegate 来获取事件。
    /// - Note: 因为会访问的控制器的 view 属性，请在 viewDidLoad 之后再设置此属性。
    public var isCustomizable: Bool {
        get {
            return self.transitionController != nil
        }
        set {
            if let transitionController = self.transitionController {
                if !newValue {
                    self.delegate = transitionController.delegate
                    self.navigationBar.isCustomizable = false
                    self.interactivePopGestureRecognizer?.isEnabled = true
                    transitionController.interactiveNavigationGestureRecognizer.isEnabled = false
                    self.transitionController = nil
                    
                    self.navigationBar.navigationBar = nil
                }
            } else if newValue {
                let transitionController = XZNavigationControllerTransitionController.init(for: self)
                self.transitionController = transitionController
                
                // 关于原生手势
                // 即使重写属性 interactivePopGestureRecognizer 也不能保证原生的返回手势不会被创建，所以我们创建了新的手势，并设置了优先级。
                self.delegate = transitionController
                self.navigationBar.isCustomizable = true
                if let popGestureRecognizer = self.interactivePopGestureRecognizer {
                    popGestureRecognizer.isEnabled = false
                    popGestureRecognizer.require(toFail: transitionController.interactiveNavigationGestureRecognizer)
                }
                
                let aClass = type(of: self)
                if objc_getAssociatedObject(aClass, &_naviagtionController) == nil {
                    objc_setAssociatedObject(aClass, &_naviagtionController, true, .OBJC_ASSOCIATION_COPY_NONATOMIC)

                    let source = XZNavigationControllerRuntime.self
                    
                    let selector11 = #selector(UINavigationController.pushViewController(_:animated:));
                    let selector12 = #selector(XZNavigationControllerRuntime.__xz_navc_override_pushViewController(_:animated:));
                    let selector13 = #selector(XZNavigationControllerRuntime.__xz_navc_exchange_pushViewController(_:animated:));
                    XZNavigationControllerRuntime.addMethod(aClass, selector: selector11, source: source, override: selector12, exchange: selector13)
                    
                    let selector21 = #selector(UINavigationController.setViewControllers(_:animated:));
                    let selector22 = #selector(XZNavigationControllerRuntime.__xz_navc_override_setViewControllers(_:animated:));
                    let selector23 = #selector(XZNavigationControllerRuntime.__xz_navc_exchange_setViewControllers(_:animated:));
                    XZNavigationControllerRuntime.addMethod(aClass, selector: selector21, source: source, override: selector22, exchange: selector23)
                    
                    let selector31 = #selector(UINavigationController.popViewController(animated:));
                    let selector32 = #selector(XZNavigationControllerRuntime.__xz_navc_override_popViewController(animated:));
                    let selector33 = #selector(XZNavigationControllerRuntime.__xz_navc_exchange_popViewController(animated:));
                    XZNavigationControllerRuntime.addMethod(aClass, selector: selector31, source: source, override: selector32, exchange: selector33)
                    
                    let selector41 = #selector(UINavigationController.popToViewController(_:animated:));
                    let selector42 = #selector(XZNavigationControllerRuntime.__xz_navc_override_popToViewController(_:animated:));
                    let selector43 = #selector(XZNavigationControllerRuntime.__xz_navc_exchange_popToViewController(_:animated:));
                    XZNavigationControllerRuntime.addMethod(aClass, selector: selector41, source: source, override: selector42, exchange: selector43)
                    
                    let selector51 = #selector(UINavigationController.popToRootViewController(animated:));
                    let selector52 = #selector(XZNavigationControllerRuntime.__xz_navc_override_popToRootViewController(animated:));
                    let selector53 = #selector(XZNavigationControllerRuntime.__xz_navc_exchange_popToRootViewController(animated:));
                    XZNavigationControllerRuntime.addMethod(aClass, selector: selector51, source: source, override: selector52, exchange: selector53)
                }
                
                // 栈内控制启用自定义功能
                for viewController in viewControllers {
                    XZNavigationControllerRuntime.__xz_navc_navigationController(self, customizeViewController: viewController)
                }
                
                // 因为非自定义模式，转场走的时原生的逻辑，因此即使在转场过程被调用，如下处理也是没有问题的。
                if let navigationBar = (topViewController as? XZNavigationBarCustomizable)?.navigationBarIfLoaded {
                    self.navigationBar.isHidden           = navigationBar.isHidden
                    self.navigationBar.isTranslucent      = navigationBar.isTranslucent
                    self.navigationBar.prefersLargeTitles = navigationBar.prefersLargeTitles
                    self.navigationBar.navigationBar      = navigationBar
                }
                
            }
        }
    }
    
    @available(iOS, introduced: 13.0, deprecated: 13.0, renamed: "isCustomizable")
    public var isNavigationBarCustomizable: Bool {
        get {
            return self.isCustomizable
        }
        set {
            self.isCustomizable = newValue
        }
    }
    
    public private(set) var transitionController: XZNavigationControllerTransitionController? {
        get {
            return objc_getAssociatedObject(self, &_transitionController) as? XZNavigationControllerTransitionController
        }
        set {
            objc_setAssociatedObject(self, &_transitionController, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

extension XZNavigationControllerRuntime {

    /// 向控制器的 viewWillAppear/viewDidAppear 中注入代码。
    /// - Attention: This method is private, do not use it directly.
    @objc public static func __xz_navc_navigationController(_ navigationController: UINavigationController, customizeViewController viewController: UIViewController) {
        guard navigationController is XZNavigationController else {
            return
        }
        let aClass = type(of: viewController)
        guard objc_getAssociatedObject(aClass, &_viewController) == nil else { return }
        objc_setAssociatedObject(aClass, &_viewController, true, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        guard viewController is XZNavigationBarCustomizable else { return }
        
        // 注入 viewWillAppear 用以更新导航条状态
        addMethod(aClass, selector: #selector(UIViewController.viewWillAppear(_:)),
                  source: XZNavigationControllerRuntime.self,
                  override: #selector(XZNavigationControllerRuntime.__xz_navc_override_viewWillAppear(_:)),
                  exchange: #selector(XZNavigationControllerRuntime.__xz_navc_exchange_viewWillAppear(_:)))
        // 注入 viewDidAppear 用来将自定义导航条与原生导航条绑定
        addMethod(aClass, selector: #selector(UIViewController.viewDidAppear(_:)),
                  source: XZNavigationControllerRuntime.self,
                  override: #selector(XZNavigationControllerRuntime.__xz_navc_override_viewDidAppear(_:)),
                  exchange: #selector(XZNavigationControllerRuntime.__xz_navc_exchange_viewDidAppear(_:)))
    }
    
    fileprivate static func addMethod(_ aClass: AnyClass, selector: Selector, source: AnyClass, override: Selector, exchange: Selector) {
        if let method = xz_objc_class_getInstanceMethod(aClass, selector) {
            // 方法已实现，添加待交换的方法
            if let methodForExchange = class_getInstanceMethod(source, exchange) {
                if class_addMethod(aClass, exchange, method_getImplementation(methodForExchange), method_getTypeEncoding(methodForExchange)) {
                    if let method3 = class_getInstanceMethod(aClass, exchange) {
                        method_exchangeImplementations(method, method3)
                    }
                }
            }
        } else if let methodForOverride = class_getInstanceMethod(source, override) {
            class_addMethod(aClass, selector, method_getImplementation(methodForOverride), method_getTypeEncoding(methodForOverride))
        }
    }
    
    /// 转场已开始，转场动画即将开始：更新导航条样式。
    /// - Attention: This method is private, do not use it directly.
    @objc static public func __xz_navc_viewController(_ viewController: UIViewController, viewWillAppear animated: Bool) {
        //print("\(type(of: viewController)).\(#function) \(animated)")
        guard let navigationController = viewController.navigationController as? XZNavigationController else {
            return
        }
        guard navigationController.isCustomizable == true else {
            return
        }
        guard let viewController = viewController as? XZNavigationBarCustomizable else {
            return
        }
        guard let customNavigationBar = viewController.navigationBarIfLoaded else {
            return
        }
        
        let navigationBar = navigationController.navigationBar
        if navigationBar.isTranslucent != customNavigationBar.isTranslucent {
            navigationBar.isTranslucent = customNavigationBar.isTranslucent
        }
        if navigationBar.prefersLargeTitles != customNavigationBar.prefersLargeTitles {
            navigationBar.prefersLargeTitles = customNavigationBar.prefersLargeTitles
        }
        if navigationController.isNavigationBarHidden != customNavigationBar.isHidden {
            navigationController.setNavigationBarHidden(customNavigationBar.isHidden, animated: animated)
        }
    }
    
    /// 转场完成，自定义导航条与原生导航条绑定。任何对原生导航条的操作，都会保存到自定义导航条上，并用于下一次转场。
    /// - Attention: This method is private, do not use it directly.
    @objc static public func __xz_navc_viewController(_ viewController: UIViewController, viewDidAppear animated: Bool) {
        //print("\(type(of: viewController)).\(#function) \(animated)")
        guard let navigationController = viewController.navigationController as? XZNavigationController else {
            return
        }
        guard navigationController.isCustomizable == true else {
            return
        }
        navigationController.navigationBar.navigationBar = (viewController as? XZNavigationBarCustomizable)?.navigationBarIfLoaded
    }
    
    /// 转场开始，自定义导航条与原生导航条解除绑定。转场过程中的导航条操作，最终会在 viewWillAppear 的注入逻辑覆盖。
    /// - Attention: This method is private, do not use it directly.
    @objc static public func __xz_navc_prepareForNavigationTransition(_ navigationController: UINavigationController) {
        navigationController.navigationBar.navigationBar = nil
    }
}

private var _viewController = 0
private var _naviagtionController = 0
private var _transitionController = 0

