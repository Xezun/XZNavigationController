//
//  UINavigationBar.swift
//  XZKit
//
//  Created by Xezun on 2017/7/11.
//
//

import UIKit
import XZDefines

extension UINavigationBar {
    
    /// 记录了当前正在显示的自定义的导航条。在控制器转场过程中，此属性为 nil 。
    public internal(set) var navigationBar: XZNavigationBarProtocol? {
        get {
            return objc_getAssociatedObject(self, &_navigationBar) as? XZNavigationBarProtocol
        }
        set {
            // 移除旧的
            if let oldValue = self.navigationBar {
                oldValue.navigationBar = nil
                oldValue.removeFromSuperview()
            }
            
            // 记录新值
            objc_setAssociatedObject(self, &_navigationBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            // 添加新的
            if let newValue = newValue {
                newValue.frame = bounds
                newValue.navigationBar = self
                // 使用 autoresizing 布局，自定义导航条的 frame 会在父视图变化时改变，
                // 而自定义导航条父视图，在转场时会发生改变。
                super.addSubview(newValue)
            }
        }
    }
    
    /// 导航条是否已开启自定义。
    public internal(set) var isCustomizable: Bool {
        get {
            return __xz_navc_isCustomizable()
        }
        set {
            if newValue == isCustomizable {
                return
            }
            
            if newValue {
                let OldClass = type(of: self)
                
                if let CustomizableClass = objc_getAssociatedObject(OldClass, &_CustomizableClass) as? UINavigationBar.Type {
                    _ = object_setClass(self, CustomizableClass)
                } else if let CustomizableClass = xz_objc_createClass(OldClass, { (CustomizableClass) in
                        xz_objc_class_copyMethodsFromClass(CustomizableClass, XZNavigationControllerCustomizableNavigationBar.self);
                }) as? UINavigationBar.Type {
                    objc_setAssociatedObject(OldClass, &_CustomizableClass, CustomizableClass, .OBJC_ASSOCIATION_ASSIGN)
                    _ = object_setClass(self, CustomizableClass)
                } else {
                    fatalError("无法自定义\(OldClass)")
                }
            } else {
                object_setClass(self, self.superclass!)
            }
        }
    }
    
}

extension XZNavigationControllerCustomizableNavigationBar {
    
    open override var isHidden: Bool {
        get {
            return __xz_navc_isHidden()
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
            return __xz_navc_isTranslucent()
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
            return __xz_navc_prefersLargeTitles()
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
        __xz_navc_layoutSubviews()

        if let customNavigationBar = navigationBar {
            customNavigationBar.frame = bounds
        }
    }

    // 当原生导航条添加子视图时，保证自定义导航条始终显示在最上面。

    open override func addSubview(_ view: UIView) {
        __xz_navc_addSubview(view)

        if let navigationBar = navigationBar, navigationBar != view {
            __xz_navc_bringSubview(toFront: navigationBar)
        }
    }

    open override func bringSubviewToFront(_ view: UIView) {
        __xz_navc_bringSubview(toFront: view)

        if let navigationBar = navigationBar, navigationBar != view {
            __xz_navc_bringSubview(toFront: navigationBar)
        }
    }

    open override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        __xz_navc_insertSubview(view, aboveSubview: siblingSubview)
        
        if siblingSubview == navigationBar {
            __xz_navc_bringSubview(toFront: siblingSubview)
        }
    }

    open override func insertSubview(_ view: UIView, at index: Int) {
        __xz_navc_insertSubview(view, at: index)

        if let navigationBar = navigationBar {
            __xz_navc_bringSubview(toFront: navigationBar)
        }
    }

    open override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        __xz_navc_insertSubview(view, belowSubview: siblingSubview)
        if navigationBar == view {
            __xz_navc_bringSubview(toFront: view)
        }
    }
    
}

private var _navigationBar = 0
private var _CustomizableClass = 0;
