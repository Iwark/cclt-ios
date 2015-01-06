//
//  AppViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/6/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
    
    let kNavTitleVerticalPosPad:CGFloat = 1.0 // NavigationBarのタイトルの位置(iPad)
    let kNavBarColor = Settings.Colors.mainColor
    
    var _appLoading = false
    
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
            let font = Settings.Fonts.IPad.navTitleFont
            UINavigationBar.appearance().titleTextAttributes = ["UITextAttributeFont": font]
            UINavigationBar.appearance().setTitleVerticalPositionAdjustment(kNavTitleVerticalPosPad, forBarMetrics: .Default)
        }
        
        UINavigationBar.appearance().titleTextAttributes = ["NSForegroundColorAttributeName": UIColor.whiteColor()]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        println("appearing!")
        self.navBarColor = kNavBarColor
    }
    
    func startLoading(header:String="　", footer:String="読み込み中...") {
        _appLoading = true
        if let window = UIApplication.sharedApplication().keyWindow {
            JHProgressHUD.sharedHUD.showInWindow(window, withHeader: header, andFooter: footer)
        }
    }
    
    func stopLoading() {
        _appLoading = false
        JHProgressHUD.sharedHUD.hide()
    }
    
}