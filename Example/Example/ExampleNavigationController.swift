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

        self.isNavigationBarCustomizable = true
    }

    
}
