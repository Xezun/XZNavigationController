//
//  ExampleLastViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/18.
//

import UIKit
import XZNavigationController

class ExampleLastViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.title        = "尾页"
        navigationBar.barTintColor = .systemBrown
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
    
}

extension ExampleLastViewController: XZNavigationBarCustomizable {

}
