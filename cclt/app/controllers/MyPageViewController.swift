//
//  MyPageViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/19/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit
import SwifteriOS

class MyPageViewController: AppViewController {
   
    @IBOutlet weak var myPageScrollView: MyPageScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アカウント情報があればログインして表示
        if let curatorID: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("curator-uid"){
        
            println(curatorID)
        
        } else {
            
            // なければLoginModalViewの表示
            let loginView = LoginView(frame: self.view.frame)
            self.view.addSubview(loginView)
            
            let swifter = Swifter(consumerKey: "vo8yTUNiHAaNzniQ1tjWEzkkD", consumerSecret: "bsukuoOqZPMJ3XwqcUVRvtOdDdBsaslz3GlEnNg1AG270KqMdY")
            
            let callbackURL = NSURL(string: "cclt://auth/twitter")
            
            swifter.authorizeWithCallbackURL(callbackURL!, success: {
                (accessToken: SwifterCredential.OAuthAccessToken?, response: NSURLResponse) in
                
                println(accessToken)
                
                },
                failure: {
                    (error: NSError) in
                    
                    println(error)
                    
            })

        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = "マイページ"
    }
    
}
