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
    @objc(__xz_isCustomizable) var isCustomizable: Bool {
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
    
    @objc(__xz_setHidden:) func setHidden(_ isHidden: Bool) {
    }
    @objc(__xz_setTranslucent:) func setTranslucent(_ isTranslucent: Bool) {
    }
    @objc(__xz_setPrefersLargeTitles:) func setPrefersLargeTitles(_ prefersLargeTitles: Bool) {
    }
    
}

private class XZCustomizableNavigationBar: UINavigationBar {
    
    override func setHidden(_ isHidden: Bool) {
        super.isHidden = isHidden
    }
    
    override func setTranslucent(_ isTranslucent: Bool) {
        super.isTranslucent = isTranslucent
    }
    
    override func setPrefersLargeTitles(_ prefersLargeTitles: Bool) {
        super.prefersLargeTitles = prefersLargeTitles
    }
    
    // 重写自定义类的 isCustomizable 属性的 getter 方法，使其返回 true 。
    override var isCustomizable: Bool {
        get {
            return true
        }
        set {
            super.isCustomizable = newValue
        }
    }
    
    // 以会影响布局的属性，在赋值时，如果有自定义导航条，则直接设置自定义导航条。
    // 然后自定义导航条对应的 setter.didSet 方法，会再将值同步给原生导航条。
    
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            if let navigationBar = navigationBar {
                navigationBar.isHidden = newValue
            } else {
                super.isHidden = newValue
            }
        }
    }
    
    override var isTranslucent: Bool {
        get {
            return super.isTranslucent
        }
        set {
            if let navigationBar = navigationBar {
                navigationBar.isTranslucent = newValue
            } else {
                super.isTranslucent = newValue
            }
        }
    }
    
    @available(iOS 11.0, *)
    override var prefersLargeTitles: Bool {
        get {
            return super.prefersLargeTitles
        }
        set {
            if let navigationBar = navigationBar {
                navigationBar.prefersLargeTitles = newValue
            } else {
                super.prefersLargeTitles = newValue
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let customNavigationBar = navigationBar {
            customNavigationBar.frame = bounds
        }
    }
    
    // 当原生导航条添加子视图时，保证自定义导航条始终显示在最上面。

    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        if let customNavigationBar = navigationBar {
            super.bringSubviewToFront(customNavigationBar)
        }
    }
    
    override func bringSubviewToFront(_ view: UIView) {
        super.bringSubviewToFront(view)
        if let customNavigationBar = navigationBar {
            if view == customNavigationBar {
                return
            }
            super.bringSubviewToFront(customNavigationBar)
        }
    }
    
    override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        super.insertSubview(view, aboveSubview: siblingSubview)
        if siblingSubview == navigationBar {
            super.bringSubviewToFront(siblingSubview)
        }
    }
    
    override func insertSubview(_ view: UIView, at index: Int) {
        super.insertSubview(view, at: index)
        
        if let customNavigationBar = navigationBar {
            super.bringSubviewToFront(customNavigationBar)
        }
    }
    
    override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        if view == navigationBar {
            super.addSubview(view)
        } else {
            super.insertSubview(view, belowSubview: siblingSubview)
        }
    }

}

private var _navigationBar = 0
private var _CustomizableClass = 0;
