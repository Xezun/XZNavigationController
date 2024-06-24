//
//  XZNavigationControllerAnimationController.swift
//  XZKit
//
//  Created by Xezun on 2017/7/11.
//
//

import UIKit


/// 动画控制器，处理了导航控制器的转场过程中的动画效果。
public class XZNavigationControllerAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 导航控制器。
    public unowned let navigationController: XZNavigationController
    /// 导航行为。
    public let operation: UINavigationController.Operation
    /// 此属性存在时，表示当前是一个交互式转场。
    public let interactiveTransition: UIPercentDrivenInteractiveTransition?
    /// 是否为交互性动画。
    public var isInteractive: Bool {
        return interactiveTransition != nil
    }
    
    public init?(for navigationController: XZNavigationController, operation: UINavigationController.Operation, isInteractive: Bool) {
        guard operation != .none else { return nil }
        self.navigationController  = navigationController
        self.operation             = operation
        self.interactiveTransition = (isInteractive ? UIPercentDrivenInteractiveTransition() : nil)
        super.init()
    }
    
}

extension XZNavigationControllerAnimationController {
    
    /// 系统默认转场动画时长为 0.3 秒，此处也一样。
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    /// 4. 配置转场动画。
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch operation {
        case .push:
            animatePushTransition(using: transitionContext)
        case .pop:
            animatePopTransition(using: transitionContext)
        default:
            break
        }
    }
    
    /// 6. 转场结束。
    public func animationEnded(_ transitionCompleted: Bool) {
        // 此方法在 UIViewControllerContextTransitioning.completeTransition(_:) 中被调用。
        // 且调用后，系统内部处理了一些操作，致使在这里处理取消导航的恢复操作无法生效，所以取消导航的恢复操作放在了动画的 completion 回调中处理。
        // navigationController.transitionController.navigationController(navigationController, animationController: self, animatedTransitionDidEnd: transitionCompleted)
        // 在此取 navigationController.topViewController 可能并不准确，因为 viewDidAppear 比此方法先调用，
        // 如果在 viewDidAppear 中 push 了新的控制器，那么这里的获取到的 topViewController 就是新的控制器。
        // 因此在此方法中无法设置当前的自定义导航条。
    }
    
    public func animationOptions(forTransition operation: UINavigationController.Operation) -> UIView.AnimationOptions {
        if interactiveTransition == nil {
            return .curveEaseInOut
        }
        return .curveLinear
    }
    
    /// 执行 Push 动画。
    ///
    /// - Parameter transitionContext: 转场信息。
    public func animatePushTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC   = transitionContext.viewController(forKey: .from),
              let fromView = transitionContext.view(forKey: .from),
              let toVC     = transitionContext.viewController(forKey: .to),
              let toView   = transitionContext.view(forKey: .to)
        else {
            return transitionContext.completeTransition(false)
        }
        
        let containerView = transitionContext.containerView
        let direction: CGFloat = containerView.effectiveUserInterfaceLayoutDirection == .leftToRight ? 1.0 : -1.0
        
        // 配置旧视图
        let fromViewFrame1 = transitionContext.initialFrame(for: fromVC)
        let fromViewFrame2 = fromViewFrame1.offsetBy(dx: direction * -fromViewFrame1.width / 3.0, dy: 0)
        fromView.frame = fromViewFrame1
        containerView.addSubview(fromView)
        
        // 配置新视图
        let toViewFrame2 = transitionContext.finalFrame(for: toVC)
        let toViewFrame1 = toViewFrame2.offsetBy(dx: direction * toViewFrame2.width, dy: 0)
        toView.frame = toViewFrame1
        containerView.addSubview(toView)
        
        // 阴影
        let shadowFrame2 = containerView.bounds // vc 可能要比 containerView 小，不能直接用 vc 的 frame
        let shadowView = XZNavigationTransitionShadowView.init(frame: shadowFrame2.offsetBy(dx: direction * shadowFrame2.width, dy: 0))
        containerView.insertSubview(shadowView, belowSubview: toView)
        
        // 转场容器与导航条不在同一个层次上，坐标系需要转换。
        let navigationBar = navigationController.navigationBar // 系统导航条。
        navigationBar.customNavigationBar = nil
        let navBarRect = navigationBar.convert(navigationBar.bounds, to: containerView)
        
        // 获取自定义导航条，并配置导航条。
        let fromNavBar = (fromVC as? XZNavigationBarCustomizable)?.navigationBarIfLoaded
        var fromNavBarFrame2: CGRect?
        if let navBar = fromNavBar, !navBar.isHidden {
            // from 导航条使用原始状态
            let fromNavBarFrame1 = navigationBar.convert(navBar.frame, to: containerView)
            navBar.frame = fromNavBarFrame1
            fromNavBarFrame2 = fromNavBarFrame1.offsetBy(dx: direction * -navBarRect.width / 3.0, dy: 0)
            containerView.insertSubview(navBar, aboveSubview: fromView)
            // 解决因为状态栏变化而造成的导航条布局问题：导航条 frame 没变，但是覆盖状态栏的背景，需要根据状态栏变化。
            navBar.setNeedsLayout()
        }
        
        let toNavBar = (toVC as? XZNavigationBarCustomizable)?.navigationBarIfLoaded
        var toNavBarFrame2: CGRect?
        if let navBar = toNavBar, !navBar.isHidden {
            navBar.frame = navBarRect.offsetBy(dx: direction * navBarRect.width, dy: 0)
            toNavBarFrame2 = navBarRect
            containerView.insertSubview(navBar, aboveSubview: toView)
            navBar.setNeedsLayout()
        }
        
        if fromNavBar != nil && toNavBar != nil {
            navigationBar.superview?.sendSubviewToBack(navigationBar)
        }
        
        // todo: 执行动画时，是否需要将系统导航条放到转场容器最底层，作为自定义导航条的背景。
        
        // 由于 tabBar 在最顶层，所以平移一个屏宽，而非三分之一
        var tabBar: UITabBar?
        var tabBarFrame2 = CGRect.zero
        if direction < 0, let tabBarController = navigationController.tabBarController {
            let viewControllers = navigationController.viewControllers
            if toVC.hidesBottomBarWhenPushed {
                if !viewControllers[0 ..< viewControllers.count - 1].contains(where: { $0.hidesBottomBarWhenPushed }) {
                    tabBar = tabBarController.tabBar
                    let frame = tabBar!.frame
                    tabBarFrame2 = frame.offsetBy(dx: direction * -frame.width, dy: 0)
                }
            }
        }
        
        let duration = transitionDuration(using: transitionContext)
        let options  = animationOptions(forTransition: .push)
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            fromView.frame   = fromViewFrame2
            toView.frame     = toViewFrame2
            shadowView.frame = shadowFrame2

            if let frame = fromNavBarFrame2 {
                fromNavBar!.frame = frame
            }
            if let frame = toNavBarFrame2 {
                toNavBar!.frame = frame
            }
            
            if let tabBar = tabBar {
                tabBar.frame = tabBarFrame2
                tabBar.isFrozen = true
            }
        }, completion: { (finished) in
            // 删除阴影。
            shadowView.removeFromSuperview()
            
            // 自定义导航条在转场过程中，仅仅作为转场效果出现，将起放置到导航条上有导航控制器处理，所以这里要移除。
            navigationBar.superview?.bringSubviewToFront(navigationBar)
            fromNavBar?.removeFromSuperview()
            toNavBar?.removeFromSuperview()
            
            // 恢复 TabBar 。
            tabBar?.isFrozen = false
            
            // 恢复导航条状态。如果将恢复操作放在 animationEnded(_:) 方法中，在Demo中没有问题，但是在实际项目中却遇到了未知问题：
            // 页面A导航条透明，页面B导航条不透明。从 B 返回（pop）到 A ，如果操作取消，那么最终 B 页面的导航条属性为不透明，但是从布局（控制器view）上看却是透明的。
            // 由于 animationEnded(_:) 是在控制器 viewDidAppear 或 viewDidDisappear 之后被调用（见页面底部文档），此时再来恢复导航条样式已无济于事。
            // 至于在Demo中放在前后都可以，可能是因为计算少速度快导致的，但是项目计算量多时，放后面就无法及时抓取正确的状态，从而导致问题。
            if transitionContext.transitionWasCancelled {
                if let fromNavBar = fromNavBar {
                    navigationBar.isTranslucent      = fromNavBar.isTranslucent
                    navigationBar.tintColor          = fromNavBar.tintColor
                    navigationBar.prefersLargeTitles = fromNavBar.prefersLargeTitles
                    self.navigationController.setNavigationBarHidden(fromNavBar.isHidden, animated: true)
                } else {
                    // 转场前的状态无法记录，状态无法恢复
                }
                transitionContext.completeTransition(false)
                navigationBar.customNavigationBar = fromNavBar
            } else {
                transitionContext.completeTransition(true)
                navigationBar.customNavigationBar = toNavBar;
            }
        })
    }

    
    /// 执行 pop 动画。
    ///
    /// - Parameter transitionContext: 转场信息。
    public func animatePopTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC   = transitionContext.viewController(forKey: .from),
              let fromView = transitionContext.view(forKey: .from),
              let toVC     = transitionContext.viewController(forKey: .to),
              let toView   = transitionContext.view(forKey: .to)
        else {
            return transitionContext.completeTransition(false)
        }
        
        let containerView = transitionContext.containerView
        let direction: CGFloat = containerView.effectiveUserInterfaceLayoutDirection == .leftToRight ? 1.0 : -1.0
        
        // 配置旧视图。
        let fromViewFrame1 = transitionContext.initialFrame(for: fromVC)
        let fromViewFrame2 = fromViewFrame1.offsetBy(dx: direction * fromViewFrame1.width, dy: 0)
        fromView.frame = fromViewFrame1
        containerView.addSubview(fromView)
        
        // 配置新视图。
        let toViewFrame2 = transitionContext.finalFrame(for: toVC)
        let toViewFrame1 = toViewFrame2.offsetBy(dx: direction * -toViewFrame2.width / 3.0, dy: 0)
        toView.frame = toViewFrame1
        containerView.insertSubview(toView, belowSubview: fromView)
        
        // 阴影
        let shadowFrame1 = containerView.bounds
        let shadowFrame2 = shadowFrame1.offsetBy(dx: direction * shadowFrame1.width, dy: 0)
        let shadowView = XZNavigationTransitionShadowView.init(frame: shadowFrame1)
        containerView.insertSubview(shadowView, belowSubview: fromView)
        
        // 转场容器与导航条不在同一个层次上，坐标系需要转换。
        let navigationBar = navigationController.navigationBar // 系统导航条。
        navigationBar.customNavigationBar = nil
        let navBarRect = navigationBar.convert(navigationBar.bounds, to: containerView)
        
        // 获取自定义导航条，并配置导航条。
        let fromNavBar = (fromVC as? XZNavigationBarCustomizable)?.navigationBarIfLoaded
        var fromNavBarFrame2: CGRect?
        if let navBar = fromNavBar, !navBar.isHidden {
            let fromNavBarFrame1 = navigationBar.convert(navBar.frame, to: containerView)
            navBar.frame = fromNavBarFrame1
            fromNavBarFrame2 = fromNavBarFrame1.offsetBy(dx: direction * navBarRect.width, dy: 0)
            containerView.insertSubview(navBar, aboveSubview: fromView)
            navBar.setNeedsLayout()
        }
        
        let toNavBar = (toVC as? XZNavigationBarCustomizable)?.navigationBarIfLoaded
        var toNavBarFrame2: CGRect?
        if let navBar = toNavBar, !navBar.isHidden {
            navBar.frame = navBarRect.offsetBy(dx: direction * -navBarRect.width / 3.0, dy: 0)
            toNavBarFrame2 = navBarRect
            containerView.insertSubview(navBar, aboveSubview: toView)
            navBar.setNeedsLayout()
        }
        
        if fromNavBar != nil && toNavBar != nil {
            navigationBar.superview?.sendSubviewToBack(navigationBar)
        }
         
        // 由于 tabBar 的层级比较高，且将 tabBar 添加到 containerView 上，会导致 tabBar 在动画时到显示不正确
        // 所以 tabBar 是平移一个宽度，而页面仅平移了三分之一
        var tabBar: UITabBar?
        var tabBarFrame2 = CGRect.zero
        if direction < 0, let tabBarController = navigationController.tabBarController {
            let viewControllers = navigationController.viewControllers
            if fromVC.hidesBottomBarWhenPushed {
                if !viewControllers.contains(where: { $0.hidesBottomBarWhenPushed }) {
                    tabBar = tabBarController.tabBar
                    let frame = tabBar!.frame;
                    tabBar!.frame = CGRect(x: direction * -frame.width, y: frame.origin.y, width: frame.width, height: frame.height);
                    tabBarFrame2 = CGRect(x: 0, y: frame.origin.y, width: frame.width, height: frame.height)
                }
            }
        }
        
        let duration = transitionDuration(using: transitionContext)
        let options = animationOptions(forTransition: .push)
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            fromView.frame   = fromViewFrame2
            toView.frame     = toViewFrame2
            shadowView.frame = shadowFrame2
            
            if let frame = fromNavBarFrame2 {
                fromNavBar!.frame = frame
            }
            if let frame = toNavBarFrame2 {
                toNavBar!.frame = frame
            }
            
            if let tabBar = tabBar {
                tabBar.frame = tabBarFrame2
                tabBar.isFrozen = true
            }
        }, completion: { (finished) in
            // 删除阴影。
            shadowView.removeFromSuperview()

            // 自定义导航条在转场过程中，仅仅作为转场效果出现，将起放置到导航条上有导航控制器处理，所以这里要移除。
            navigationBar.superview?.bringSubviewToFront(navigationBar)
            fromNavBar?.removeFromSuperview()
            toNavBar?.removeFromSuperview()
            
            // 恢复 TabBar 。
            tabBar?.isFrozen = false
            
            if transitionContext.transitionWasCancelled {
                // 如果转场取消，恢复导航条样式。
                // 如果将恢复操作放在 animationEnded(_:) 方法中，在Demo中没有问题，但是在实际项目中却遇到了未知问题：
                // 页面A导航条透明，页面B导航条不透明。从 B 返回（pop）到 A ，如果操作取消，那么最终 B 页面的导航条属性为不透明，但是从布局（控制器view）上看却是透明的。
                // 由于 animationEnded(_:) 是在控制器 viewDidAppear 或 viewDidDisappear 之后被调用（见页面底部文档），此时再来恢复导航条样式已无济于事。
                // 至于在Demo中放在前后都可以，可能是因为计算少速度快导致的，但是项目计算量达时，放后面就无法及时抓取正确的状态，从而导致问题。
                if let fromNavBar = fromNavBar {
                    navigationBar.isTranslucent      = fromNavBar.isTranslucent
                    navigationBar.tintColor          = fromNavBar.tintColor
                    navigationBar.prefersLargeTitles = fromNavBar.prefersLargeTitles
                    self.navigationController.setNavigationBarHidden(fromNavBar.isHidden, animated: true)
                } else {
                    // 状态无法恢复
                }
                transitionContext.completeTransition(false)
                navigationBar.customNavigationBar = fromNavBar
            } else {
                transitionContext.completeTransition(true)
                navigationBar.customNavigationBar = toNavBar // 其实可以不要
            }
        })
    }
    
}

/// 转场过程中的阴影视图。
fileprivate class XZNavigationTransitionShadowView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor     = UIColor.white
        self.layer.shadowColor   = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius  = 5.0
        self.layer.shadowOffset  = .zero
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




// 转场过程中，各个函数先后执行顺序：
//Push:
//
//navigationController(_:animationControllerFor:from:to:)
//navigationController(_:interactionControllerFor:)
//<Example.SampleViewController: 0x7fa1a4434440> viewDidLoad()
//<Example.SampleViewController: 0x7fa1a6835bb0> viewWillDisappear
//<Example.SampleViewController: 0x7fa1a4434440> viewWillAppear
//navigationController(_:willShow:animated:)
//animateTransition(using:)
//animatePushTransition(using:) Config Animation.
//<Example.SampleViewController: 0x7fa1a4434440> viewWillLayoutSubviews()
//<Example.SampleViewController: 0x7fa1a4434440> viewDidLayoutSubviews()
//animatePushTransition(using:) Animation finished 1.
//<Example.SampleViewController: 0x7fa1a6835bb0> viewDidDisappear
//<Example.SampleViewController: 0x7fa1a4434440> viewDidAppear
//navigationController(_:didShow:animated:)
//animationEnded
//animationController(_:animatedTransitionDidEnd:)
//animatePushTransition(using:) Animation finished 2.
//
//Pop:
//
//navigationController(_:animationControllerFor:from:to:)
//navigationController(_:interactionControllerFor:)
//<Example.SampleViewController: 0x7fa1a4436850> viewWillDisappear
//<Example.SampleViewController: 0x7fa1a4434440> viewWillAppear
//navigationController(_:willShow:animated:)
//animateTransition(using:)
//animatePopTransition(using:) Config Animation.
//animatePopTransition(using:) Animation finished 1.
//<Example.SampleViewController: 0x7fa1a4436850> viewDidDisappear
//<Example.SampleViewController: 0x7fa1a4434440> viewDidAppear
//navigationController(_:didShow:animated:)
//animationEnded
//animationController(_:animatedTransitionDidEnd:)
//animatePopTransition(using:) Animation finished 2.
//
//
//Push Cancelled:
//
//navigationController(_:animationControllerFor:from:to:)
//navigationController(_:interactionControllerFor:)
//<Example.SampleViewController: 0x7fa1a683f830> viewDidLoad()
//<Example.SampleViewController: 0x7fa1a4436850> viewWillDisappear
//<Example.SampleViewController: 0x7fa1a683f830> viewWillAppear
//navigationController(_:willShow:animated:)
//animateTransition(using:)
//animatePushTransition(using:) Config Animation.
//<Example.SampleViewController: 0x7fa1a683f830> viewWillLayoutSubviews()
//<Example.SampleViewController: 0x7fa1a683f830> viewDidLayoutSubviews()
//animatePushTransition(using:) Animation finished 1.
//<Example.SampleViewController: 0x7fa1a683f830> viewWillDisappear
//<Example.SampleViewController: 0x7fa1a683f830> viewDidDisappear
//<Example.SampleViewController: 0x7fa1a4436850> viewWillAppear
//<Example.SampleViewController: 0x7fa1a4436850> viewDidAppear
//animationEnded
//animationController(_:animatedTransitionDidEnd:)
//animatePushTransition(using:) Animation finished 2.
//
//Pop Cancelled:
//
//navigationController(_:animationControllerFor:from:to:)
//navigationController(_:interactionControllerFor:)
//<Example.SampleViewController: 0x7fa1a4436850> viewWillDisappear
//<Example.SampleViewController: 0x7fa1a4434440> viewWillAppear
//navigationController(_:willShow:animated:)
//animateTransition(using:)
//animatePopTransition(using:) Config Animation.
//animatePopTransition(using:) Animation finished 1.
//<Example.SampleViewController: 0x7fa1a4434440> viewWillDisappear
//<Example.SampleViewController: 0x7fa1a4434440> viewDidDisappear
//<Example.SampleViewController: 0x7fa1a4436850> viewWillAppear
//<Example.SampleViewController: 0x7fa1a4436850> viewDidAppear
//animationEnded
//animationController(_:animatedTransitionDidEnd:)
//animatePopTransition(using:) Animation finished 2.
