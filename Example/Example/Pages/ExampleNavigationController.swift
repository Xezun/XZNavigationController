//
//  ExampleNavigationController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/16.
//

import UIKit
import XZNavigationController

class ExampleNavigationController: UINavigationController, XZNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.isCustomizable  = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        print("\(#function) \(vc)")
        super.show(vc, sender: sender)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        print("\(#function) \(viewController)")
        super.pushViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        print("\(#function) \(viewControllers.count)")
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    override var viewControllers: [UIViewController] {
        willSet {
            print("\(#function).setter \(newValue.count)")
        }
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        print("\(#function) \(animated)")
        return super.popViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        print("\(#function) \(viewController)")
        return super.popToViewController(viewController, animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        print("\(#function) \(animated)")
        return super.popToRootViewController(animated: animated)
    }

}
