//
//  UITabBar.swift
//  XZKit
//
//  Created by Xezun on 2017/7/11.
//
//

import UIKit

// 在 right-to-left 布局的环境中，当导航控制器使用了自定义的转场动画后，
// tabBar 在转场的过程中的动画效果，与 left-to-right 环境一样，不符合要求。
// 但是在转场的过程中，将 tabBar 添加的转场动画，不能生效，因此利用运行时机制，
// 在动画的过程中，让其它地方不能再修改 tabBar 的 frame 以避免这个问题。

extension UITabBar {
    
    /// 当此属性为 true 时，可以通过 *isFrozen* 属性冻结 tabBar 防止其它地方修改 frame 值。
    @objc(xz_isFreezable) var isFreezable: Bool {
        return false
    }
    
    /// 是否冻结。此属性为 true 时，更改属性 *frame* 不会生效。
    var isFrozen: Bool {
        get {
            return (objc_getAssociatedObject(self, &_isFrozen) as? Bool) == true
        }
        set {
            objc_setAssociatedObject(self, &_isFrozen, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            
            if isFreezable {
                return
            }
            
            let TabBarClass = type(of: self)
            if let FreezableTabBarClass = objc_getAssociatedObject(TabBarClass, &_FreezableTabBarClass) as? AnyClass {
                _ = object_setClass(self, FreezableTabBarClass)
            } else if let FreezableTabBarClass = xz_objc_createClass(TabBarClass, { (FreezableTabBarClass) in
                    xz_objc_class_copyMethodsFromClass(FreezableTabBarClass, XZFreezableTabBar.self)
            }) as? UITabBar.Type {
                _ = object_setClass(self, FreezableTabBarClass)
                objc_setAssociatedObject(TabBarClass, &_FreezableTabBarClass, FreezableTabBarClass, .OBJC_ASSOCIATION_ASSIGN)
            } else {
                // tabBar 的动画可能异常
            }
        }
    }
    
}

private class XZFreezableTabBar: UITabBar {
    
    /// 返回 true 。
    @objc override var isFreezable: Bool {
        return true
    }
    
    /// 自定义类的 frame 属性，在修改值时，先判断当前是否允许修改。
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            if isFrozen {
                return
            }
            super.frame = newValue
        }
    }
    
    override var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            if isFrozen {
                return
            }
            super.bounds = newValue
        }
    }
    
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            if isFrozen {
                return
            }
            super.isHidden =  newValue
        }
    }
}

private var _isFrozen = 0
private var _FreezableTabBarClass = 0
