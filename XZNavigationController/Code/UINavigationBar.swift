//
//  UINavigationBar.swift
//  XZKit
//
//  Created by Xezun on 2017/7/11.
//
//

import UIKit

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
    public internal(set) var customNavigationBar: XZNavigationBarProtocol? {
        get {
            return objc_getAssociatedObject(self, &_customNavigationBar) as? (UIView & XZNavigationBarProtocol)
        }
        set {
            let oldValue = self.customNavigationBar
            
            if newValue === oldValue {
                return
            }

            // 移除旧的
            oldValue?.removeFromSuperview()
            
            // 添加新的
            if let newValue = newValue {
                newValue.frame = bounds
                newValue.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                super.addSubview(newValue)
                
                // 复制样式，在外部处理：
                // 在转场过程中，要先更新导航条，然后才能转场，最后才将导航条放到系统导航条上，所以到这一步样式其实已经复制了。
            }
            
            // 记录新值
            objc_setAssociatedObject(self, &_customNavigationBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 导航条是否可以自定义。
    @objc(xz_isCustomizable) var isCustomizable: Bool {
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
                        xz_objc_class_copyMethodsFromClass(NewClass, XZCustomizableNavigationBar.self);
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

private class XZCustomizableNavigationBar: UINavigationBar {
    
    // 重写自定义类的 isCustomizable 属性的 getter 方法，使其返回 true 。
    override var isCustomizable: Bool {
        get {
            return true
        }
        set {
            super.isCustomizable = newValue
        }
    }
    
    // 会影响布局的属性，在赋值时，同步到自定义导航条中。
    
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            super.isHidden = newValue
            if let customNavigationBar = customNavigationBar {
                customNavigationBar.isHidden = newValue
            }
        }
    }
    
    override var isTranslucent: Bool {
        get {
            return super.isTranslucent
        }
        set {
            super.isTranslucent = newValue
            if let customNavigationBar = customNavigationBar {
                customNavigationBar.isTranslucent = newValue
            }
        }
    }
    
    @available(iOS 11.0, *)
    override var prefersLargeTitles: Bool {
        get {
            return super.prefersLargeTitles
        }
        set {
            super.prefersLargeTitles = newValue
            if let customNavigationBar = customNavigationBar {
                customNavigationBar.prefersLargeTitles = newValue
            }
        }
    }
    
    // 当原生导航条添加子视图时，保证自定义导航条始终显示在最上面。

    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        if let customNavigationBar = customNavigationBar {
            super.bringSubviewToFront(customNavigationBar)
        }
    }
    
    override func bringSubviewToFront(_ view: UIView) {
        super.bringSubviewToFront(view)
        if let customNavigationBar = customNavigationBar {
            if view == customNavigationBar {
                return
            }
            super.bringSubviewToFront(customNavigationBar)
        }
    }
    
    override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        super.insertSubview(view, aboveSubview: siblingSubview)
        if siblingSubview == customNavigationBar {
            super.bringSubviewToFront(siblingSubview)
        }
    }
    
    override func insertSubview(_ view: UIView, at index: Int) {
        super.insertSubview(view, at: index)
        
        if let customNavigationBar = customNavigationBar {
            super.bringSubviewToFront(customNavigationBar)
        }
    }
    
    override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        if view == customNavigationBar {
            super.addSubview(view)
        } else {
            super.insertSubview(view, belowSubview: siblingSubview)
        }
    }
    
}

private var _customNavigationBar = 0
private var _CustomizableClass = 0;
