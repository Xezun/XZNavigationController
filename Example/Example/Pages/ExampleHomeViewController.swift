//
//  ExampleHomeViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/12.
//

import UIKit
import XZNavigationController

class ExampleHomeViewController: UITableViewController, XZNavigationBarCustomizable, XZNavigationGestureDrivable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.title = "首页"
        self.navigationBar.barTintColor = .brown
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
    
    @IBAction func navigationBarHiddenChanged(_ sender: UISwitch) {
        navigationBar.setHidden(sender.isOn, animated: true)
    }
    
    @IBAction func navigationBarTranslucentChanged(_ sender: UISwitch) {
        navigationBar.isTranslucent = sender.isOn
    }
    
    @IBAction func navigationBarPrefersLargeTitlesChanged(_ sender: UISwitch) {
        navigationBar.prefersLargeTitles = sender.isOn
    }
    
}

