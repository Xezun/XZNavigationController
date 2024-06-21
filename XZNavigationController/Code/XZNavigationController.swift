//
//  XZNavigationController.swift
//  XZKit
//
//  Created by Xezun on 2017/2/17.
//  Copyright © 2017年 XEZUN INC. All rights reserved.
//

import UIKit
import XZDefines

// 为了将更新导航条的操作放在 viewWillAppear 中：
// 一、 方法交换，重写 UIViewController 基类的 viewWillAppear 方法，遇到一下问题：
//      1. 某些页面，交换后的方法不执行（猜测可能是因为Swift消息派发机制，没有把方法按 objc 消息派发问题）
//      2. 控制器重写的逻辑，在交换方法的逻辑之后运行，导致页面可能没有按照自定义导航条的配置来展示。
//      3. 重写 UIViewController 基类，影响较大。
// 二、重写 UINavigationController 的 addChildViewController 方法。
//      1. 方法不调用
// 三、监听 viewControllers 属性
//      1. KVO 触发

/// XZNavigationController 提供了 全屏手势 和 自定义导航条 的功能。
/// - Note: 当栈内控制器支持自定义时，系统自带导航条将不可见（非隐藏）。
/// - Note: 当控制器专场时，自动根据控制器自定义导航条状态，设置系统导航条状态。
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
                    self.delegate = nil
                    self.navigationBar.isCustomizable = false
                     self.interactivePopGestureRecognizer?.isEnabled = true
                    transitionController.interactiveNavigationGestureRecognizer.isEnabled = false
                    self.transitionController = nil
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

                    let source = XZNavigationControllerRuntimeController.self
                    
                    let selector11 = #selector(UINavigationController.pushViewController(_:animated:));
                    let selector12 = #selector(XZNavigationControllerRuntimeController.__xz_override_pushViewController(_:animated:));
                    let selector13 = #selector(XZNavigationControllerRuntimeController.__xz_exchange_pushViewController(_:animated:));
                    XZNavigationControllerRuntimeController.addMethod(aClass, selector: selector11, source: source, override: selector12, exchange: selector13)
                    
                    let selector21 = #selector(UINavigationController.setViewControllers(_:animated:));
                    let selector22 = #selector(XZNavigationControllerRuntimeController.__xz_override_setViewControllers(_:animated:));
                    let selector23 = #selector(XZNavigationControllerRuntimeController.__xz_exchange_setViewControllers(_:animated:));
                    XZNavigationControllerRuntimeController.addMethod(aClass, selector: selector21, source: source, override: selector22, exchange: selector23)
                    
                    let selector31 = #selector(UINavigationController.popViewController(animated:));
                    let selector32 = #selector(XZNavigationControllerRuntimeController.__xz_override_popViewController(animated:));
                    let selector33 = #selector(XZNavigationControllerRuntimeController.__xz_exchange_popViewController(animated:));
                    XZNavigationControllerRuntimeController.addMethod(aClass, selector: selector31, source: source, override: selector32, exchange: selector33)
                    
                    let selector41 = #selector(UINavigationController.popToViewController(_:animated:));
                    let selector42 = #selector(XZNavigationControllerRuntimeController.__xz_override_popToViewController(_:animated:));
                    let selector43 = #selector(XZNavigationControllerRuntimeController.__xz_exchange_popToViewController(_:animated:));
                    XZNavigationControllerRuntimeController.addMethod(aClass, selector: selector41, source: source, override: selector42, exchange: selector43)
                    
                    let selector51 = #selector(UINavigationController.popToRootViewController(animated:));
                    let selector52 = #selector(XZNavigationControllerRuntimeController.__xz_override_popToRootViewController(animated:));
                    let selector53 = #selector(XZNavigationControllerRuntimeController.__xz_exchange_popToRootViewController(animated:));
                    XZNavigationControllerRuntimeController.addMethod(aClass, selector: selector51, source: source, override: selector52, exchange: selector53)
                    
                    for viewController in viewControllers {
                        XZNavigationControllerRuntimeController.__xz_customizeViewController(viewController)
                    }
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

extension XZNavigationControllerRuntimeController {

    /// 向控制器的 viewWillAppear/viewDidAppear 中注入代码。
    @objc public static func __xz_customizeViewController(_ viewController: UIViewController) {
        let aClass = type(of: viewController)
        guard objc_getAssociatedObject(aClass, &_viewController) == nil else { return }
        objc_setAssociatedObject(aClass, &_viewController, true, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        guard viewController is XZNavigationBarCustomizable else { return }
        
        // 注入 viewWillAppear 用以更新导航条状态
        addMethod(aClass, selector: #selector(UIViewController.viewWillAppear(_:)),
                  source: XZNavigationControllerRuntimeController.self,
                  override: #selector(XZNavigationControllerRuntimeController.__xz_override_viewWillAppear(_:)),
                  exchange: #selector(XZNavigationControllerRuntimeController.__xz_exchange_viewWillAppear(_:)))
        // 注入 viewDidAppear 用来将自定义导航条与原生导航条绑定
        addMethod(aClass, selector: #selector(UIViewController.viewDidAppear(_:)),
                  source: XZNavigationControllerRuntimeController.self,
                  override: #selector(XZNavigationControllerRuntimeController.__xz_override_viewDidAppear(_:)),
                  exchange: #selector(XZNavigationControllerRuntimeController.__xz_exchange_viewDidAppear(_:)))
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
    @objc static public func __xz_viewController(_ viewController: UIViewController, viewWillAppear animated: Bool) {
        // print("\(type(of: viewController)).\(#function) \(animated)")
        guard let viewController = viewController as? XZNavigationBarCustomizable else { return }
        guard let customNavigationBar = viewController.navigationBarIfLoaded else {
            return
        }
        guard let navigationController = viewController.navigationController else {
            return
        }
        let navigationBar = navigationController.navigationBar
        if navigationBar.isTranslucent != customNavigationBar.isTranslucent {
            navigationBar.isTranslucent      = customNavigationBar.isTranslucent
        }
        if navigationBar.prefersLargeTitles != customNavigationBar.prefersLargeTitles {
            navigationBar.prefersLargeTitles = customNavigationBar.prefersLargeTitles
        }
        if navigationController.isNavigationBarHidden != customNavigationBar.isHidden {
            navigationController.setNavigationBarHidden(customNavigationBar.isHidden, animated: animated)
        }
    }
    
    // 转场完成，自定义导航条与原生导航条绑定。任何对原生导航条的操作，都会保存到自定义导航条上，并用于下一次转场。
    @objc static public func __xz_viewController(_ viewController: UIViewController, viewDidAppear animated: Bool) {
        viewController.navigationController?.navigationBar.navigationBar = (viewController as? XZNavigationBarCustomizable)?.navigationBarIfLoaded
    }
    
    // 转场开始，自定义导航条与原生导航条解除绑定。转场过程中的导航条操作，最终会在 viewWillAppear 的注入逻辑覆盖。
    @objc static public func __xz_prepareForNavigationTransition(_ navigationController: UINavigationController) {
        navigationController.navigationBar.navigationBar = nil
    }
}

private var _viewController = 0
private var _naviagtionController = 0
private var _transitionController = 0

