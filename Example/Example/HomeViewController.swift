//
//  HomeViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/12.
//

import UIKit
import XZNavigationController

class HomeViewController: UITableViewController, XZNavigationBarCustomizable, XZNavigationGestureDrivable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.title = "Home"
        self.navigationBar.barTintColor = .red
        self.navigationBar.isTranslucent = false
    }

    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController, viewControllerForGestureNavigation operation: UINavigationController.Operation) -> UIViewController? {
        if operation == .push {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            return sb.instantiateViewController(withIdentifier: "next")
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, edgeInsetsForGestureNavigation operation: UINavigationController.Operation) -> NSDirectionalEdgeInsets? {
        return .init(top: 0, leading: 20, bottom: 0, trailing: 20)
    }
}

