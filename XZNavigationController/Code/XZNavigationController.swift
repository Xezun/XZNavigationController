//
//  XZNavigationController.swift
//  XZKit
//
//  Created by Xezun on 2017/2/17.
//  Copyright © 2017年 XEZUN INC. All rights reserved.
//

import UIKit


/// XZNavigationController 提供了 全屏手势 和 自定义导航条 的功能。
/// - Note: 当栈内控制器支持自定义时，系统自带导航条将不可见（非隐藏）。
/// - Note: 当控制器专场时，自动根据控制器自定义导航条状态，设置系统导航条状态。
public protocol XZNavigationController: UINavigationController {

}

extension XZNavigationController {
    
    /// 开启自定义导航栏模式。
    /// - Note: 当前导航控制的 delegate 事件已被 transitionController 接管。可通过设置 transitionController 的 delegate 来获取事件。
    /// - Note: 因为会访问的控制器的 view 属性，请在 viewDidLoad 之后再设置此属性。
    public var isNavigationBarCustomizable: Bool {
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
            }
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

/// 自定义导航条可以继承 XZNavigationBar 也可以继承其它视图控件，实现 XZNavigationBarProtocol 协议即可。
/// 自定义导航条所必须实现的协议。
/// - Note: 因为 tintColor 会自动从父视图继承，所以自定义导航条没有设置 tintColor 的话，那么最终可能会影响自定义导航条的外观，因为自定义导航条的父视图，在转场过程中会发生变化。
public protocol XZNavigationBarProtocol: UIView {
    var isTranslucent: Bool { get set }
    var prefersLargeTitles: Bool { get set }
}

/// 导航条是否可以自定义。
public protocol XZNavigationBarCustomizable: UIViewController {
    
    /// 控制器自定义导航条。
    /// - Note: 导航条的获取时机会被 viewDidLoad 更早，因此，在其中访问到 view 属性，可能会造成控制器生命周期提前。
    var navigationBarIfLoaded: XZNavigationBarProtocol? { get }
    
}

private var _transitionController = 0

