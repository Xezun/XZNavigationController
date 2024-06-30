//
//  ExampleNextViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/16.
//

import UIKit
import XZNavigationController

class ExampleNextViewController: UITableViewController {
    
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var translucentSwitch: UISwitch!
    @IBOutlet weak var prefersLargeTitlesSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.title        = "中间页"
        navigationBar.barTintColor = .systemMint
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        如下操作会导致自定义导航条丢失，因为 set 操作会认为是转场开始，而移除了导航条。
//        但实际上第二次 set 时，并没有转场发生，viewDidAppear 也不会执行。
//        if let navigationController = navigationController {
//            let viewControllers = navigationController.viewControllers
//            navigationController.setViewControllers([], animated: false)
//            navigationController.setViewControllers(viewControllers, animated: false)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        hiddenSwitch.isOn = navigationBar.isHidden
        translucentSwitch.isOn = navigationBar.isTranslucent
        prefersLargeTitlesSwitch.isOn = navigationBar.prefersLargeTitles
    }

    @IBAction func unwindToBack(_ unwindSegue: UIStoryboardSegue) {
        
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

    @IBOutlet weak var nextHiddenSwitch: UISwitch!
    @IBOutlet weak var nextTranslucentSwitch: UISwitch!
    @IBOutlet weak var nextPrefersLargeTitlesSwitch: UISwitch!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "next" else {
            return
        }
        if let navigationBar = (segue.destination as? XZNavigationBarCustomizable)?.navigationBarIfLoaded {
            navigationBar.isHidden           = nextHiddenSwitch.isOn
            navigationBar.isTranslucent      = nextTranslucentSwitch.isOn
            navigationBar.prefersLargeTitles = nextPrefersLargeTitlesSwitch.isOn
        }
    }
    
}

extension ExampleNextViewController: XZNavigationBarCustomizable {
 

}

extension ExampleNextViewController: XZNavigationGestureDrivable {
    
    func navigationController(_ navigationController: UINavigationController, viewControllerForGestureNavigation operation: UINavigationController.Operation) -> UIViewController? {
        if operation == .push {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "last")
            if let navigationBar = (vc as? XZNavigationBarCustomizable)?.navigationBarIfLoaded {
                navigationBar.isHidden = nextHiddenSwitch.isOn
                navigationBar.isTranslucent = nextTranslucentSwitch.isOn
                navigationBar.prefersLargeTitles = nextPrefersLargeTitlesSwitch.isOn
            }
            return vc
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, edgeInsetsForGestureNavigation operation: UINavigationController.Operation) -> NSDirectionalEdgeInsets? {
        return .init(top: 0, leading: 20, bottom: 0, trailing: 20)
    }
    
}
