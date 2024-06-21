//
//  UINavigationBar.swift
//  XZKit
//
//  Created by Xezun on 2017/7/11.
//
//

import UIKit
import XZDefines

// 关于系统导航条：
// 如果 isTranslucent == false ，那么导航条背景色 alpha 会被设置为 1.0，但是大标题模式背景色却是白色的。
// 如果 isTranslucent == true ，设置透明色，则导航条可以透明。
//
// 设置导航条透明：
// self.backgroundColor = UIColor.clear
// self.isHidden        = false
// self.barTintColor    = UIColor(white: 1.0, alpha: 0)
// self.shadowImage     = UIImage()
// self.isTranslucent   = true
// self.setBackgroundImage(UIImage(), for: .default)

extension UINavigationBar {
    
    /// 记录了当前正在显示的自定义的导航条。在控制器转场过程中，此属性为 nil 。
    public internal(set) var navigationBar: XZNavigationBarProtocol? {
        get {
            return objc_getAssociatedObject(self, &_navigationBar) as? XZNavigationBarProtocol
        }
        set {
            let oldValue = self.navigationBar
            
            if newValue === oldValue {
                return
            }

            // 移除旧的
            oldValue?.removeFromSuperview()
            
            // 添加新的
            if let newValue = newValue {
                newValue.frame = bounds
                // 设置 autoresizing 后，自定义导航条的 frame 会在父视图变化时改变，难以预期
                super.addSubview(newValue)
                
                // 复制样式，在外部处理：
                // 在转场过程中，要先更新导航条，然后才能转场，最后才将导航条放到系统导航条上，所以到这一步样式其实已经复制了。
            }
            
            // 记录新值
            objc_setAssociatedObject(self, &_navigationBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 导航条是否可以自定义。
    var isCustomizable: Bool {
        get {
            return false
        }
        set {
            let oldValue = isCustomizable
            if newValue == oldValue {
                return
            }
            
            if oldValue {
                object_setClass(self, self.superclass!)
            } else {  
                let OldClass = type(of: self)
                
                if let NewClass = objc_getAssociatedObject(OldClass, &_CustomizableClass) as? UINavigationBar.Type {
                    _ = object_setClass(self, NewClass)
                } else if let NewClass = xz_objc_createClass(OldClass, { (NewClass) in
                        xz_objc_class_copyMethodsFromClass(NewClass, XZNavigationControllerCustomizableNavigationBar.self);
                }) as? UINavigationBar.Type {
                    objc_setAssociatedObject(OldClass, &_CustomizableClass, NewClass, .OBJC_ASSOCIATION_ASSIGN)
                    _ = object_setClass(self, NewClass)
                } else {
                    fatalError("无法自定义\(OldClass)")
                }
            }
        }
    }
    
}

extension XZNavigationControllerCustomizableNavigationBar {
    
    open override var isHidden: Bool {
        get {
            return __xz_isHidden()
        }
        set {
            if let navigationBar = navigationBar {
                navigationBar.isHidden = newValue
            } else {
                setHidden(newValue)
            }
        }
    }
    
    open override var isTranslucent: Bool {
        get {
            return __xz_isTranslucent()
        }
        set {
            if let navigationBar = navigationBar {
                navigationBar.isTranslucent = newValue
            } else {
                setTranslucent(newValue)
            }
        }
    }
    
    @available(iOS 11.0, *)
    open override var prefersLargeTitles: Bool {
        get {
            return __xz_prefersLargeTitles()
        }
        set {
            if let navigationBar = navigationBar {
                navigationBar.prefersLargeTitles = newValue
            } else {
                setPrefersLargeTitles(newValue)
            }
        }
    }
    
    open override func layoutSubviews() {
        __xz_layoutSubviews()

        if let customNavigationBar = navigationBar {
            customNavigationBar.frame = bounds
        }
    }

    // 当原生导航条添加子视图时，保证自定义导航条始终显示在最上面。

    open override func addSubview(_ view: UIView) {
        __xz_addSubview(view)

        if let navigationBar = navigationBar {
            __xz_bringSubview(toFront: navigationBar)
        }
    }

    open override func bringSubviewToFront(_ view: UIView) {
        __xz_bringSubview(toFront: view)

        if let navigationBar = navigationBar {
            if view == navigationBar {
                return
            }
            __xz_bringSubview(toFront: navigationBar)
        }
    }

    open override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        __xz_insertSubview(view, aboveSubview: siblingSubview)
        
        if siblingSubview == navigationBar {
            __xz_bringSubview(toFront: siblingSubview)
        }
    }

    open override func insertSubview(_ view: UIView, at index: Int) {
        __xz_insertSubview(view, at: index)

        if let navigationBar = navigationBar {
            __xz_bringSubview(toFront: navigationBar)
        }
    }

    open override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        if view == navigationBar {
            __xz_addSubview(view)
        } else {
            __xz_insertSubview(view, belowSubview: siblingSubview)
        }
    }
    
}

private var _navigationBar = 0
private var _CustomizableClass = 0;
