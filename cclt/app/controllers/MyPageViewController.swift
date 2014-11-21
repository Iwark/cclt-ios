//
//  MyPageViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/19/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class MyPageViewController: AppViewController {
   
    @IBOutlet weak var myPageScrollView: MyPageScrollView!
    
    let kSegueToLoginWindow = "MyPageToLoginModal"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アカウント情報があればログインして表示
        if let curatorID = NSUserDefaults.standardUserDefaults().objectForKey("curator-uid"){
        
            println(curatorID)
        
        } else {
            
            // なければLoginModalViewControllerへ遷移
            
            self.performSegueWithIdentifier(kSegueToLoginWindow, sender: self)

        }
        
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = "マイページ"
    }
    
}
