//
//  ExampleNextViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/16.
//

import UIKit
import XZNavigationController

class ExampleNextViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.title              = "中间页"
        navigationBar.barTintColor       = .systemMint
        navigationBar.isHidden           = true
        navigationBar.isTranslucent      = true
        navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

extension ExampleNextViewController: XZNavigationBarCustomizable {
 

}

extension ExampleNextViewController: XZNavigationGestureDrivable {
    
    func navigationController(_ navigationController: UINavigationController, viewControllerForGestureNavigation operation: UINavigationController.Operation) -> UIViewController? {
        if operation == .push {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            return sb.instantiateViewController(withIdentifier: "last")
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, edgeInsetsForGestureNavigation operation: UINavigationController.Operation) -> NSDirectionalEdgeInsets? {
        return .init(top: 0, leading: 20, bottom: 0, trailing: 20)
    }
    
}
