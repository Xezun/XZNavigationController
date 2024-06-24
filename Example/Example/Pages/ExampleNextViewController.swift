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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("\(type(of: self)).\(#function) \(animated)")
        super.viewWillAppear(animated)
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

    @IBOutlet weak var isHiddenSwitch: UISwitch!
    @IBOutlet weak var isTranslucentSwitch: UISwitch!
    @IBOutlet weak var prefersLargeTitlesSwitch: UISwitch!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? XZNavigationBarCustomizable,
           let navigationBar = viewController.navigationBarIfLoaded {
            navigationBar.isHidden = isHiddenSwitch.isOn
            navigationBar.isTranslucent = isTranslucentSwitch.isOn
            navigationBar.prefersLargeTitles = prefersLargeTitlesSwitch.isOn
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
                navigationBar.isHidden = isHiddenSwitch.isOn
                navigationBar.isTranslucent = isTranslucentSwitch.isOn
                navigationBar.prefersLargeTitles = prefersLargeTitlesSwitch.isOn
            }
            return vc
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, edgeInsetsForGestureNavigation operation: UINavigationController.Operation) -> NSDirectionalEdgeInsets? {
        return .init(top: 0, leading: 20, bottom: 0, trailing: 20)
    }
    
}
