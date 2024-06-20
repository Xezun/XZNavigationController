//
//  XZNavigationControllerTransitionController.swift
//  XZKit
//
//  Created by Xezun on 2018/12/31.
//

import Foundation
import XZDefines

/// 转场控制器，接管了导航控制的代理。
public final class XZNavigationControllerTransitionController: NSObject {
    
    /// 导航控制器的代理，如果设置了此属性，那么转场动画将优先使用代理定义的转场。
    public weak var delegate: UINavigationControllerDelegate?
    /// 导航手势对象。
    public let interactiveNavigationGestureRecognizer: UIPanGestureRecognizer
    /// 导航控制器。
    public unowned let navigationController: XZNavigationController
    
    public init(for navigationController: XZNavigationController) {
        self.navigationController = navigationController
        self.interactiveNavigationGestureRecognizer = UIPanGestureRecognizer.init()
        super.init()
        self.interactiveNavigationGestureRecognizer.maximumNumberOfTouches = 1
        self.interactiveNavigationGestureRecognizer.delegate = self
        self.navigationController.view.addGestureRecognizer(interactiveNavigationGestureRecognizer)
        self.interactiveNavigationGestureRecognizer.addTarget(self, action: #selector(interactiveNavigationGestureRecognizerAction(_:)))
    }
    
    /// 交互式的转场控制器，只有在手势触发的转场过程中，此属性才有值。
    public private(set) var interactiveAnimationController: XZNavigationControllerAnimationController?
}

extension XZNavigationControllerTransitionController: UINavigationControllerDelegate {
    
    // 转场过程中，方法执行的顺序。
    // navigationController(_:animationControllerFor:from:to:)
    // navigationController(_:interactionControllerFor:)
    // navigationController(_:willShow:animated:)
    // animateTransition(using:)
    // navigationController(_:didShow:animated:)
    // animationEnded 在动画的回调中触发
    
    /// 1. 获取转场动画控制器。
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 转场开始，自定义导航条从原生导航条上移除。
        navigationController.navigationBar.navigationBar = nil // (toVC as? XZNavigationBarCustomizable)?.navigationBarIfLoaded;
        // 优先使用自定义转场
        if let animationController = delegate?.navigationController?(navigationController, animationControllerFor: operation, from: fromVC, to: toVC) {
            return animationController
        }
        // 交互性转场。
        if let animationController = self.interactiveAnimationController {
            return animationController
        }
        // 普通的动画转场。
        return XZNavigationControllerAnimationController.init(for: self.navigationController, operation: operation, isInteractive: false)
    }
    
    /// 2. 动画控制器的交互控制器。
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let interactionController = delegate?.navigationController?(navigationController, interactionControllerFor: animationController) {
            return interactionController
        }
        return (animationController as? XZNavigationControllerAnimationController)?.interactiveTransition
    }
    
    /// 3. 新的控制器将要显示。
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 此方法会在 viewDidLoad 之后，但是在转场动画开始之前触发；转场如果取消，此方法不会调用。
        // 需要在转场动画开始前更新导航条样式，因为在进入自定义转场动画时，控制器的布局已经确定。
        // 导航控制器第一次显示时，栈底控制器如果不是通过初始化方法传入的，可能会造成此方法会被调用，但是 didShow 不调用，所以需要转场事件的回调。
        // 此方法触发时，viewController 已经加入到导航栈中
        
        // animated = false 时，上面两个方法不会触发。
        navigationController.navigationBar.navigationBar = nil
        
        // 更新导航条状态
        if let navigationBar = (viewController as? XZNavigationBarCustomizable)?.navigationBarIfLoaded {
            // 有一种情形，从 A 页面 Push 到 B 页面，如果在 B.viewWillAppear 中调用
            // `navigationController.setNavigationBarHidden(true, animated: animated)`
            // 即使已经将 B.navigationBar 添加到原生导航条上，B.navigationBar 也收不到 setHidden(true) 的消息，
            // 大概是因为 animated 的原因，设置隐藏的操作被延迟了。
            navigationController.navigationBar.isTranslucent      = navigationBar.isTranslucent
            navigationController.navigationBar.prefersLargeTitles = navigationBar.prefersLargeTitles
            if navigationController.isNavigationBarHidden != navigationBar.isHidden {
                navigationController.setNavigationBarHidden(navigationBar.isHidden, animated: animated)
            }
        } else {
            // 没有自定义导航条，导航条样式保持不变。新页面使用系统导航条，样式值与当前自定义导航条一致。
        }
        
        delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
    
    /// 5. 导航控制器显示了指定的控制器。转场取消的时候，此方法不会调用。
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // 设置 customNavigationBar 的值，其实在自定义转场动画中已处理。但是非动画转场，不会走自定义转场动画的逻辑，所以这里需要补上。
        // 另外，如果转场取消，此方法不会调用，属性 customNavigationBar 的值，也是在自定义转场动画的逻辑中处理的，
        navigationController.navigationBar.navigationBar = (viewController as? XZNavigationBarCustomizable)?.navigationBarIfLoaded
        
        delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }
    
    /// 转发未实现的代理方法，此方法直接返回 delegate 。
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return delegate
    }
    
    public override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        }
        return delegate?.responds(to: aSelector) == true
    }
}


extension XZNavigationControllerTransitionController {
    
    /// 手势事件。
    @objc private func interactiveNavigationGestureRecognizerAction(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            interactiveNavigationGestureRecognizerDidBegin(gestureRecognizer)
        case .changed:
            interactiveNavigationGestureRecognizerDidChange(gestureRecognizer)
        case .failed:
            fallthrough
        case .cancelled:
            fallthrough
        case .ended:
            interactiveNavigationGestureRecognizerDidEnd(gestureRecognizer)
        default:
            break
        }
    }
    
    /// 手势开始。通过判断手势方向来确定手势的行为。
    private func interactiveNavigationGestureRecognizerDidBegin(_ panGestureRecognizer: UIPanGestureRecognizer) {
        guard interactiveAnimationController == nil else { return }
        
        switch navigationOperation(for: panGestureRecognizer) {
        case .push:
            // 默认情况下，不可以导航到下一级。
            guard let viewController = navigationController.topViewController as? XZNavigationGestureDrivable else { return }
            guard let nextVC = viewController.navigationController(navigationController, viewControllerForGestureNavigation: .push) else { return }
            /// 手势开始的导航行为。
            self.interactiveAnimationController = XZNavigationControllerAnimationController.init(for: navigationController, operation: .push, isInteractive: true)
            navigationController.pushViewController(nextVC, animated: true)
            
        case .pop:
            // 只有一个控制器时，不能 pop
            let viewControllers = navigationController.viewControllers
            guard viewControllers.count > 1 else { return }
            
            self.interactiveAnimationController = XZNavigationControllerAnimationController.init(for: navigationController, operation: .pop, isInteractive: true)
            
            if let viewController = navigationController.topViewController as? XZNavigationGestureDrivable {
                if let nextVC = viewController.navigationController(navigationController, viewControllerForGestureNavigation: .pop) {
                    navigationController.popToViewController(nextVC, animated: true)
                    return
                }
            }
            navigationController.popViewController(animated: true)
        default:
            break
        }
    }
    
    /// 当手势状态发生改变是，更新动画。
    private func interactiveNavigationGestureRecognizerDidChange(_ panGestureRecognizer: UIPanGestureRecognizer) {
        guard let animationController = self.interactiveAnimationController else { return }
        guard let interactionController = animationController.interactiveTransition else { return }
        
        let t = panGestureRecognizer.translation(in: nil)
        let d = t.x / navigationController.view.bounds.width
        switch navigationController.view.effectiveUserInterfaceLayoutDirection {
        case .rightToLeft:
            if animationController.operation == .push {
                interactionController.update(max(0, d))
            } else if animationController.operation == .pop {
                interactionController.update(-min(0, d))
            }
        case .leftToRight:
            if animationController.operation == .push {
                interactionController.update(-min(0, d))
            } else if animationController.operation == .pop {
                interactionController.update(max(0, d))
            }
        default:
            fatalError()
        }
    }
    
    /// 手势结束了。
    private func interactiveNavigationGestureRecognizerDidEnd(_ panGestureRecognizer: UIPanGestureRecognizer) {
        guard let animationController = self.interactiveAnimationController else { return }
        self.interactiveAnimationController = nil
        guard let interactiveTransition = animationController.interactiveTransition else { return }
        
        let velocity = panGestureRecognizer.velocity(in: nil).x
        let PERCENT: CGFloat = 0.4
        let VELOCITY: CGFloat = 400
        switch navigationController.view.effectiveUserInterfaceLayoutDirection {
        case .rightToLeft:
            if (animationController.operation == .push && velocity > VELOCITY) || (animationController.operation == .pop && velocity < -VELOCITY) {
                interactiveTransition.finish()
            } else {
                let t = panGestureRecognizer.translation(in: nil)
                let percent = t.x / navigationController.view.bounds.width
                if (percent > PERCENT && animationController.operation == .push) || (percent < -PERCENT && animationController.operation == .pop) {
                    interactiveTransition.finish()
                } else {
                    interactiveTransition.cancel()
                }
            }
        case .leftToRight:
            if (animationController.operation == .push && velocity < -VELOCITY) || (animationController.operation == .pop && velocity > VELOCITY) {
                interactiveTransition.finish();
            } else {
                let t = panGestureRecognizer.translation(in: nil)
                let percent = t.x / navigationController.view.bounds.width
                if (percent < -PERCENT && animationController.operation == .push) || (percent > PERCENT && animationController.operation == .pop) {
                    interactiveTransition.finish()
                } else {
                    interactiveTransition.cancel()
                }
            }
        default:
            fatalError()
        }
        
        
    }
    
    /// 根据导航控制器当前的布局方向，和手势的速度来确定手势代表的导航行为。
    private func navigationOperation(for navigationGestureRecognizer: UIPanGestureRecognizer) -> UINavigationController.Operation {
        let velocity = navigationGestureRecognizer.velocity(in: nil)
        switch navigationController.view.effectiveUserInterfaceLayoutDirection {
        case .leftToRight:
            return (velocity.x > 0 ? .pop : (velocity.x < 0 ? .push : .none))
        case .rightToLeft:
            return (velocity.x < 0 ? .pop : (velocity.x > 0 ? .push : .none))
        default:
            fatalError()
        }
    }
}


extension XZNavigationControllerTransitionController: UIGestureRecognizerDelegate {
    
    /// 此方法返回 true 手势不一定能够识别成功，所以此方法不能决定导航行为。
    public func gestureRecognizerShouldBegin(_ navigationGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationGestureRecognizer = navigationGestureRecognizer as? UIPanGestureRecognizer else { return false }
        let operation   = navigationOperation(for: navigationGestureRecognizer) 
        
        let location    = navigationGestureRecognizer.location(in: nil)
        let translation = navigationGestureRecognizer.translation(in: nil)
        let point       = CGPoint(x: location.x - translation.x, y: location.y - translation.y);
        let bounds      = navigationController.view.bounds
        
        // 滑动横向分量不足时，不识别手势
        if abs(translation.x) < abs(translation.y) * 10 {
            return false
        }
        
        switch operation {
        case .push:
            // 栈顶控制器必须有协议支持
            guard let viewController = navigationController.topViewController as? XZNavigationGestureDrivable else { return false }
            
            // 边缘检测
            if let edgeInsets = viewController.navigationController(navigationController, edgeInsetsForGestureNavigation: .push) {
                switch navigationController.view.effectiveUserInterfaceLayoutDirection {
                case .leftToRight:
                    return point.x >= bounds.maxX - edgeInsets.trailing
                case .rightToLeft:
                    return point.x <= bounds.minX + edgeInsets.trailing
                @unknown default:
                    fatalError()
                }
            }
            
            return true
        case .pop:
            // 数量必须大于 2
            guard navigationController.viewControllers.count > 1 else {
                return false
            }
            
            // pop 定制
            if let viewController = navigationController.topViewController as? XZNavigationGestureDrivable {
                // 边缘检测
                if let edgeInsets = viewController.navigationController(navigationController, edgeInsetsForGestureNavigation: .pop) {
                    switch navigationController.view.effectiveUserInterfaceLayoutDirection {
                    case .leftToRight:
                        return point.x <= bounds.minX + edgeInsets.leading
                    case .rightToLeft:
                        return point.x >= bounds.maxX - edgeInsets.leading
                    @unknown default:
                        fatalError()
                    }
                }
                // 全屏支持返回
                return true
            }
            
            // 默认支持边缘 15.0 点内侧滑返回
            switch navigationController.view.effectiveUserInterfaceLayoutDirection {
            case .leftToRight:
                return point.x <= bounds.minX + 15.0
            case .rightToLeft:
                return point.x >= bounds.maxX - 15.0
            @unknown default:
                fatalError()
            }
        default:
            return false
        }
    }
    
    /// 是否可以与其它手势同时被识别。
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    /// 导航驱动手势，是否需要在其它手势失败时才能识别，默认 false 。
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    /// 其它手势需等待导航驱动手势失败才能进行。
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
 

// 转场方法调用顺序
//
// Push 成功时：
//    navigationController(_:animationControllerFor:from:to:)
//    navigationController(_:interactionControllerFor:)
//    toVC: viewDidLoad()
//    fromVC: viewWillDisappear(_:)
//    toVC: viewWillAppear(_:)
//    navigationController(_:willShow:animated:)
//    animateTransition(using:)
//    animatePushTransition(using:)
//    fromVC: viewDidDisappear(_:)
//    toVC: viewDidAppear(_:)
//    navigationController(_:didShow:animated:)
//    animationEnded(_:)
//
// Push 取消时：
//    navigationController(_:animationControllerFor:from:to:)
//    navigationController(_:interactionControllerFor:)
//    toVC: viewDidLoad()
//    fromVC: viewWillDisappear(_:)
//    toVC: viewWillAppear(_:)
//    navigationController(_:willShow:animated:)
//    animateTransition(using:)
//    animatePushTransition(using:)
//    toVC: viewWillDisappear(_:)
//    toVC: viewDidDisappear(_:)
//    fromVC: viewWillAppear(_:)
//    fromVC: viewDidAppear(_:)
//    animationEnded(_:)
//
// Pop 成功时：
//    navigationController(_:animationControllerFor:from:to:)
//    navigationController(_:interactionControllerFor:)
//    fromVC: viewWillDisappear(_:)
//    toVC: viewWillAppear(_:)
//    navigationController(_:willShow:animated:)
//    animateTransition(using:)
//    animatePopTransition(using:)
//    fromVC: viewDidDisappear(_:)
//    toVC: viewDidAppear(_:)
//    navigationController(_:didShow:animated:)
//    animationEnded(_:)
// Pop 取消时：
//    navigationController(_:animationControllerFor:from:to:)
//    navigationController(_:interactionControllerFor:)
//    fromVC: viewWillDisappear(_:)
//    toVC: viewWillAppear(_:)
//    navigationController(_:willShow:animated:)
//    animateTransition(using:)
//    animatePopTransition(using:)
//    toVC: viewWillDisappear(_:)
//    toVC: viewDidDisappear(_:)
//    fromVC: viewWillAppear(_:)
//    fromVC: viewDidAppear(_:)
//    animationEnded(_:)
