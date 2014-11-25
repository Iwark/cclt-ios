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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アカウント情報があればログインして表示
        if let curatorID = NSUserDefaults.standardUserDefaults().objectForKey("curator-uid"){
        
            println(curatorID)
        
        } else {
            
            // なければLoginModalViewの表示
            let loginView = LoginView(frame: self.view.frame)
            self.view.addSubview(loginView)

        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = "マイページ"
    }
    
}
