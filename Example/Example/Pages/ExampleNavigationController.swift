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
//        self.isCustomizable  = false

        
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        print("\(type(of: self)).\(#function) \(type(of: viewController)) \(animated)")
        super.pushViewController(viewController, animated: animated)
    }
  
}
