//
//  ExampleNextViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/16.
//

import UIKit
import XZNavigationController

class ExampleNextViewController: UITableViewController, XZNavigationGestureDrivable, XZNavigationBarCustomizable {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func navigationController(_ navigationController: UINavigationController, viewControllerForGestureNavigation operation: UINavigationController.Operation) -> UIViewController? {
        if operation == .push {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            return sb.instantiateViewController(withIdentifier: "last")
        }
        return nil
    }

}
