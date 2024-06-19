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
                
                let aClass = UINavigationController.self
                if objc_getAssociatedObject(aClass, &_addChildViewController) == nil {
                    objc_setAssociatedObject(aClass, &_addChildViewController, true, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                    
                    let selector1 = #selector(UINavigationController.pushViewController(_:animated:));
                    let selector2 = #selector(UINavigationController.__xz_exchange_pushViewController(_:animated:));
                    let selector3 = #selector(UINavigationController.setViewControllers(_:animated:));
                    let selector4 = #selector(UINavigationController.__xz_exchange_setViewControllers(_:animated:));
                    method_exchangeImplementations(class_getInstanceMethod(aClass, selector1)!, class_getInstanceMethod(aClass, selector2)!)
                    method_exchangeImplementations(class_getInstanceMethod(aClass, selector3)!, class_getInstanceMethod(aClass, selector4)!)
                    
                    for viewController in viewControllers {
                        UINavigationController.handleViewWillAppear(for: viewController)
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

public extension UINavigationController {

//    @objc func __xz_exchange_pushViewController(_ viewController: UIViewController, animated: Bool) {
//        print("\(type(of: self)).\(#function) \(type(of: viewController)) \(animated)")
//        UINavigationController.handleViewWillAppear(for: viewController)
//        navigationBar.customNavigationBar = nil
//        // 直接写 __xz_exchange_pushViewController(viewController, animated) 会被编译器优化调用方式，从而导致循环调用
//        // 参数 animated 必须写 0 和 1 ，否则会被解析为 false
//        perform(#selector(__xz_exchange_pushViewController(_:animated:)), with: viewController, with: animated ? 1 : 0)
//    }
//
//    @objc func __xz_exchange_setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
//        navigationBar.customNavigationBar = nil
//        for viewController in viewControllers {
//            UINavigationController.handleViewWillAppear(for: viewController)
//        }
//        perform(#selector(__xz_exchange_setViewControllers(_:animated:)), with: viewControllers, with: animated ? 1 : 0)
//    }
    
    @objc(__xz_handleViewWillAppearForViewController:)
    static func handleViewWillAppear(for viewController: UIViewController) {
        let aClass = type(of: viewController)
        guard objc_getAssociatedObject(aClass, &_viewWillAppear) == nil else { return }
        objc_setAssociatedObject(aClass, &_viewWillAppear, true, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        guard viewController is XZNavigationBarCustomizable else { return }
        
        let selector1 = #selector(UIViewController.viewWillAppear(_:))
        
        if let method1 = xz_objc_class_getInstanceMethod(aClass, selector1) {
            // 方法已实现，添加待交换的方法
            let selector2 = #selector(UINavigationController.__xz_exchange_viewWillAppear(_:));
            let method2 = class_getInstanceMethod(UINavigationController.self, selector2)!
            xz_objc_class_addMethodByCopyingMethod(aClass, method2, nil)
            // 交换实现
            let method3 = class_getInstanceMethod(aClass, selector2)!
            method_exchangeImplementations(method1, method3)
        } else {
            // 方法未实现，添加一个重写的方法
            xz_objc_class_copyMethodFromClass(aClass, UINavigationController.self, selector1, nil)
        }
    }
    
    @objc(__xz_viewController:viewWillAppear:)
    static func viewController(_ viewController: UIViewController, viewWillAppear animated: Bool) {
        print("\(type(of: viewController)).\(#function) \(animated)")
        guard let viewController = viewController as? XZNavigationBarCustomizable else { return }
        guard let customNavigationBar = viewController.navigationBarIfLoaded else {
            return
        }
        guard let navigationController = viewController.navigationController else {
            return
        }
        let navigationBar = navigationController.navigationBar
        navigationBar.isTranslucent      = customNavigationBar.isTranslucent
        navigationBar.prefersLargeTitles = customNavigationBar.prefersLargeTitles
        if navigationController.isNavigationBarHidden != customNavigationBar.isHidden {
            navigationController.setNavigationBarHidden(customNavigationBar.isHidden, animated: animated)
            print("setNavigationBarHidden(\(customNavigationBar.isHidden), animated: \(animated))")
        }
    }
}

//@objc public class XZCustomizableViewController: UIViewController {
//
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        XZCustomizableViewController.viewWillAppear(self, animated: animated)
//    }
//
//    @objc func __xz_exchange_viewWillAppear(_ animated: Bool) {
//        // 直接写 __xz_exchange_viewWillAppear(animated) 会被编译器优化调用方式，从而导致循环调用
//        // 参数 animated 必须写 0 和 1 ，否则会被解析为 false
//        perform(#selector(__xz_exchange_viewWillAppear(_:)), with: animated ? 1 : 0)
//
//        XZCustomizableViewController.viewWillAppear(self, animated: animated)
//    }
//
//    @objc(__xz_viewWillAppear:animated:) public static func viewWillAppear(_ viewController: UIViewController, animated: Bool) {
//        print("\(type(of: viewController)).\(#function) \(animated)")
//        guard let viewController = viewController as? XZNavigationBarCustomizable else { return }
//        guard let customNavigationBar = viewController.navigationBarIfLoaded else {
//            return
//        }
//        guard let navigationController = viewController.navigationController else {
//            return
//        }
//        let navigationBar = navigationController.navigationBar
//        navigationBar.isTranslucent      = customNavigationBar.isTranslucent
//        navigationBar.prefersLargeTitles = customNavigationBar.prefersLargeTitles
//        if navigationController.isNavigationBarHidden != customNavigationBar.isHidden {
//            navigationController.setNavigationBarHidden(customNavigationBar.isHidden, animated: animated)
//            print("\(type(of: viewController)).\(#function) setNavigationBarHidden=\(customNavigationBar.isHidden)")
//        }
//    }
//}

private var _viewWillAppear = 0
private var _addChildViewController = 0
private var _transitionController = 0

