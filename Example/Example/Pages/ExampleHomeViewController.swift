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
        
        navigationBar.title         = "首页"
        navigationBar.barTintColor  = .brown
        navigationBar.isTranslucent = true
    }

    @IBAction func unwindToBack(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController, viewControllerForGestureNavigation operation: UINavigationController.Operation) -> UIViewController? {
        if operation == .push {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "next")
            if let navigationBar = (vc as? XZNavigationBarCustomizable)?.navigationBarIfLoaded {
                navigationBar.isHidden = isHiddenSwitch.isOn
                navigationBar.isTranslucent = isTranslucentSwitch.isOn
                navigationBar.prefersLargeTitles = prefersLargeTitlesSwitch.isOn
            }
            return vc
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
    
    @IBOutlet weak var isHiddenSwitch: UISwitch!
    @IBOutlet weak var isTranslucentSwitch: UISwitch!
    @IBOutlet weak var prefersLargeTitlesSwitch: UISwitch!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "next" else {
            return
        }
        if let navigationBar = (segue.destination as? XZNavigationBarCustomizable)?.navigationBarIfLoaded {
            navigationBar.isHidden           = isHiddenSwitch.isOn
            navigationBar.isTranslucent      = isTranslucentSwitch.isOn
            navigationBar.prefersLargeTitles = prefersLargeTitlesSwitch.isOn
        }
    }
}

