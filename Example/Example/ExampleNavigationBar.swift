//
//  ExampleNavigationBar.swift
//  Example
//
//  Created by 徐臻 on 2024/6/16.
//

import XZNavigationController

public class ExampleNavigationBar: XZNavigationBar {
    
    public override var barTintColor: UIColor? {
        didSet {
            titleLabel.backgroundColor = barTintColor
        }
    }

    public var title: String? {
        get {
            return (self.titleView as? UILabel)?.text
        }
        set {
            if titleView == nil {
                let width = UIScreen.main.bounds.width
                
                titleLabel.frame = CGRect(x: 0, y: 0, width: width, height: 44)
                titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
                titleLabel.textAlignment = .center
                titleLabel.textColor = .black
                
                largeTitleLabel.frame = CGRect(x: 16.0, y: 3.0, width: width - 32.0, height: 41.0)
                largeTitleLabel.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
                largeTitleLabel.font = UIFont.boldSystemFont(ofSize: 34)
                largeTitleLabel.textAlignment = .natural
                largeTitleLabel.textColor = .black
                
                let largeTitleView = UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: 52))
                largeTitleView.addSubview(largeTitleLabel)
                
                self.titleView = titleLabel
                self.largeTitleView = largeTitleView
            }
            titleLabel.text = newValue
            largeTitleLabel.text = newValue
        }
    }
    
    private let titleLabel = UILabel.init()
    private let largeTitleLabel = UILabel.init()
}

extension XZNavigationBarCustomizable {
    
    public var navigationBarIfLoaded: XZNavigationBarProtocol? {
        return self.navigationBar
    }
    
    public var navigationBar: ExampleNavigationBar {
        if let navigationBar = objc_getAssociatedObject(self, &_navigationBar) as? ExampleNavigationBar {
            return navigationBar
        }
        let navigationBar = ExampleNavigationBar(for: self, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        objc_setAssociatedObject(self, &_navigationBar, navigationBar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return navigationBar
    }
}

private var _navigationBar = 0
