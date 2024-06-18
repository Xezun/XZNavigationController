//
//  UINavigationBar.swift
//  XZKit
//
//  Created by Xezun on 2017/7/11.
//
//

import UIKit

private var _customNavigationBar = 0

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
    @objc(xz_isCustomizable) public internal(set) var isCustomizable: Bool {
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
                // 系统导航条始终不隐藏、全透明。
                // 系统导航条，如果 isTranslucent == false ，那么导航条背景色 alpha 会被设置为 1.0，但是大标题模式背景色却是白色的。
                // 如果 isTranslucent == true ，设置透明色，则导航条可以透明。
//                self.backgroundColor = UIColor.clear
//                self.isHidden        = false
//                self.barTintColor    = UIColor(white: 1.0, alpha: 0)
//                self.shadowImage     = UIImage()
//                self.isTranslucent   = true
//                self.setBackgroundImage(UIImage(), for: .default)
                
                let OldClass = type(of: self)
                
                if let NewClass = objc_getAssociatedObject(OldClass, &AssociationKey.NewClass) as? UINavigationBar.Type {
                    _ = object_setClass(self, NewClass)
                } else if let NewClass = xz_objc_createClass(OldClass, { (NewClass) in
                        xz_objc_class_copyMethodsFromClass(NewClass, XZCustomizableNavigationBar.self);
                }) as? UINavigationBar.Type {
                    objc_setAssociatedObject(OldClass, &AssociationKey.NewClass, NewClass, .OBJC_ASSOCIATION_ASSIGN)
                    _ = object_setClass(self, NewClass)
                } else {
                    // 不能自定义 nav bar
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
    
    
    
    // 重写自定义类的 isHidden 属性，使其 isHidden 属性不再控制导航条的显示或隐藏。
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
    
    // 重写自定义类的 isTranslucent 属性，使其 isTranslucent 属性不再控制导航条的透明。
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
    
    // 重写 prefersLargeTitles setter
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
    
    // 同步 tintColor ，避免动画过程中，因为自定义导航条不在原生导航条上，由 tintColor 引起的外观不一致问题。
    override func tintColorDidChange() {
        super.tintColorDidChange()
        customNavigationBar?.tintColor = tintColor
    }
    
    // 不可设置导航条背景。
    override func setBackgroundImage(_ backgroundImage: UIImage?, for barPosition: UIBarPosition, barMetrics: UIBarMetrics) {
        #if DEBUG
        print("因为导航条已自定义，设置原生导航条样式将不再起作用。")
        #endif
    }
    
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



private struct AssociationKey {
    static var isCustomizable = "isCustomizable"
    static var isTranslucent  = "isTranslucent"
    static var isHidden       = "isHidden"
    static var NewClass       = "NewClass"
    static var customizedBar  = "customizedBar"
}


