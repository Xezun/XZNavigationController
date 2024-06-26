//
//  ExampleLastViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/18.
//

import UIKit
import XZNavigationController

class ExampleLastViewController: UITableViewController {

    @IBOutlet weak var isHiddenSwitch: UISwitch!
    @IBOutlet weak var isTranslucentSwitch: UISwitch!
    @IBOutlet weak var prefersLargeTitlesSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.title        = "尾页"
        navigationBar.barTintColor = .systemBrown
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isHiddenSwitch.isOn = navigationBar.isHidden
        isTranslucentSwitch.isOn = navigationBar.isTranslucent
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 3 else {
            return
        }
        guard let navigationController = navigationController else { return }
        
        switch indexPath.row {
        case 0:
            navigationController.show(ExampleTestViewController.init(), sender: nil)
        case 1:
            navigationController.pushViewController(ExampleTestViewController.init(), animated: true)
        case 2:
            var viewControllers = navigationController.viewControllers
            viewControllers.append(ExampleTestViewController.init())
            navigationController.setViewControllers(viewControllers, animated: true)
        case 3:
            var viewControllers = navigationController.viewControllers
            viewControllers.append(ExampleTestViewController.init())
            navigationController.viewControllers = viewControllers
        case 4:
            navigationController.popViewController(animated: true)
        case 5:
            let vc = navigationController.viewControllers[1]
            navigationController.popToViewController(vc, animated: true)
        case 6:
            navigationController.popToRootViewController(animated: true)
        default:
            break
        }
    }
    
}

extension ExampleLastViewController: XZNavigationBarCustomizable {

}

extension ExampleLastViewController: XZNavigationGestureDrivable {
    
    func navigationController(_ navigationController: UINavigationController, viewControllerForGestureNavigation operation: UINavigationController.Operation) -> UIViewController? {
        return navigationController.viewControllers.first
    }
}




class ExampleTestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(#function)")
        view.backgroundColor = .magenta
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(#function)")
    }
}
