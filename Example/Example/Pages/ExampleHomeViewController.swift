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
        
        navigationBar.title        = "首页"
        navigationBar.barTintColor = .brown
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @IBAction func navigationBarHiddenChanged(_ sender: UISwitch) {
        navigationController?.setNavigationBarHidden(sender.isOn, animated: true)
    }

    @IBAction func navigationBarTranslucentChanged(_ sender: UISwitch) {
        navigationController?.navigationBar.isTranslucent = sender.isOn
    }

    @IBAction func navigationBarPrefersLargeTitlesChanged(_ sender: UISwitch) {
        navigationController?.navigationBar.prefersLargeTitles = sender.isOn
    }
    
    
    
    
    
}

