//
//  SettingsViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/19/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SettingsViewController: AppViewController,
SettingsTableViewDelegate {
    
    @IBOutlet weak var settingsTableView: SettingsTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.settingsTableViewDelegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = "設定"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func push(vc: UIViewController) {
        self.navController?.pushViewController(vc, animated: true)
    }
    
}
