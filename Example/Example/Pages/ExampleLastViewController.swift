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

        navigationBar.title = "尾页"
        navigationBar.barTintColor = .systemBrown
        navigationBar.isHidden = false
        navigationBar.isTranslucent = true
        navigationBar.prefersLargeTitles = false
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

extension ExampleLastViewController: XZNavigationBarCustomizable {

}
