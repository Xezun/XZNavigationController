//
//  UINavigationBar.swift
//  XZKit
//
//  Created by Xezun on 2017/7/11.
//
//

import UIKit


extension UINavigationBar {
    
    /// 记录了当前正在显示的自定义的导航条。在控制器转场过程中，此属性为 nil 。
    public internal(set) var customNavigationBar: XZNavigationBarProtocol? {
        get {
            return objc_getAssociatedObject(self, &AssociationKey.customizedBar) as? (UIView & XZNavigationBarProtocol)
        }
        set {
            if let oldNavigationBar = self.customNavigationBar {
                oldNavigationBar.removeFromSuperview() // 移除旧的
            }
            objc_setAssociatedObject(self, &AssociationKey.customizedBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            for subview in subviews {
                subview.isHidden = true // 隐藏原生视图
            }
            if let newNavigationBar = newValue {
                newNavigationBar.frame = bounds
                newNavigationBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                addSubview(newNavigationBar) // 添加新的
            }
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
                self.backgroundColor = UIColor.clear
                self.isHidden        = false
                self.barTintColor    = UIColor(white: 1.0, alpha: 0)
                self.shadowImage     = UIImage()
                self.isTranslucent   = true
                self.setBackgroundImage(UIImage(), for: .default)
                
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
            if let isHidden = objc_getAssociatedObject(self, &AssociationKey.isHidden) as? Bool {
                return isHidden
            }
            return false // 与导航条当前状态相同。
        }
        set {
            objc_setAssociatedObject(self, &AssociationKey.isHidden, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            customNavigationBar?.isHidden = newValue
        }
    }
    
    // 重写自定义类的 isTranslucent 属性，使其 isTranslucent 属性不再控制导航条的透明。
    override var isTranslucent: Bool {
        get {
            if let isTranslucent = objc_getAssociatedObject(self, &AssociationKey.isTranslucent) as? Bool {
                return isTranslucent
            }
            return true // 与导航条当前状态相同。
        }
        set {
            objc_setAssociatedObject(self, &AssociationKey.isTranslucent, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            customNavigationBar?.isTranslucent = newValue
        }
    }
    
    // 重写 prefersLargeTitles setter
    @available(iOS 11.0, *)
    override var prefersLargeTitles: Bool {
        get {
            return super.prefersLargeTitles
        }
        set {
            super.prefersLargeTitles = newValue;
            customNavigationBar?.prefersLargeTitles = newValue
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
    
}



private struct AssociationKey {
    static var isCustomizable = "isCustomizable"
    static var isTranslucent  = "isTranslucent"
    static var isHidden       = "isHidden"
    static var NewClass       = "NewClass"
    static var customizedBar  = "customizedBar"
}


