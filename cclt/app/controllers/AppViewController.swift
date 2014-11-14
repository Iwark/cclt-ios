//
//  AppViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/6/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
    
    let kNavTitleFontSizePad:CGFloat    = 22.0 // NavigationBarのタイトルのフォントサイズ（iPad）
    let kNavTitleVerticalPosPad:CGFloat = 1.0 // NavigationBarのタイトルの位置(iPad)
    let kNavBarColor = UIColor("#92e1c4", 0.9)
    
    var navTitle:String? {
        get { return self.navigationItem.title }
        set { self.navigationItem.title = newValue }
    }
    
    var navController:UINavigationController? {
        get { return self.navigationController }
    }
    
    var navBarColor:UIColor? {
        get { return kNavBarColor }
        set {
            self.navController?.navigationBar.barStyle = .BlackTranslucent
            let backImg = UIImage.imageWithColor(kNavBarColor)
            self.navController?.navigationBar.setBackgroundImage(backImg, forBarMetrics: .Default)
            UINavigationBar.appearance().barTintColor = kNavBarColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // iPadの場合のナビゲーションバー
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let font = UIFont.boldSystemFontOfSize(kNavTitleFontSizePad)
            UINavigationBar.appearance().titleTextAttributes = ["UITextAttributeFont": font]
            UINavigationBar.appearance().setTitleVerticalPositionAdjustment(kNavTitleVerticalPosPad, forBarMetrics: .Default)
        }
        
        UINavigationBar.appearance().titleTextAttributes = ["NSForegroundColorAttributeName": UIColor.whiteColor()]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        println("appearing!")
        self.navBarColor = kNavBarColor
    }
    
}