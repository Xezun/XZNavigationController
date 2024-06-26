//
//  ExampleNativeViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/21.
//

import UIKit

class ExampleNativeViewController: UITableViewController {
    
    @IBOutlet weak var isHiddenSwitch: UISwitch!
    @IBOutlet weak var isTranslucentSwitch: UISwitch!
    @IBOutlet weak var prefersLargeTitlesSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let navigationBar = navigationController?.navigationBar {
            isHiddenSwitch.isOn = navigationBar.isHidden
            isTranslucentSwitch.isOn = navigationBar.isTranslucent
            prefersLargeTitlesSwitch.isOn = navigationBar.prefersLargeTitles
        }
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
