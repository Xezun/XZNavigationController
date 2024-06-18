//
//  ExampleNavigationBar.swift
//  Example
//
//  Created by 徐臻 on 2024/6/16.
//

import XZNavigationController

public class ExampleNavigationBar: XZNavigationBar {

    public var title: String? {
        get {
            return (self.titleView as? UILabel)?.text
        }
        set {
            if titleView == nil {
                let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
                titleLabel.font = UIFont.systemFont(ofSize: 17.0)
                titleLabel.textAlignment = .center
                titleLabel.textColor = .black
                titleLabel.text = newValue
                self.titleView = titleLabel
            } else if let titleLabel = self.titleView as? UILabel {
                titleLabel.text = newValue
            }
        }
    }

}

extension XZNavigationBarCustomizable {
    
    public var navigationBarIfLoaded: XZNavigationBarProtocol? {
        return objc_getAssociatedObject(self, &_navigationBar) as? XZNavigationBarProtocol
    }
    
    public var navigationBar: ExampleNavigationBar {
        if let navigationBar = objc_getAssociatedObject(self, &_navigationBar) as? ExampleNavigationBar {
            return navigationBar
        }
        let navigationBar = ExampleNavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        objc_setAssociatedObject(self, &_navigationBar, navigationBar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return navigationBar
    }
}

private var _navigationBar = 0
