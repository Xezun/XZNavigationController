//
//  ExampleGestureViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/19.
//

import UIKit
import XZNavigationController

class ExampleGestureViewController: UITableViewController, XZNavigationGestureDrivable {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func navigationController(_ navigationController: UINavigationController, viewControllerForGestureNavigation operation: UINavigationController.Operation) -> UIViewController? {
        if operation == .push {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            return sb.instantiateViewController(withIdentifier: "next")
        }
        return nil
    }

    @IBAction func unwindToBack(_ unwindSegue: UIStoryboardSegue) {
        
    }
}
