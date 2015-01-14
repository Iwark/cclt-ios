//
//  AppViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/6/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class AppViewController: UIViewController, BackBarButtonItemDelegate {
    
    let kNavTitleVerticalPosPad:CGFloat = 1.0 // NavigationBarのタイトルの位置(iPad)
    let kNavBarColor = Settings.Colors.mainColor
    
    var _appLoading = false
    var _appLoadStartTime:NSDate!

    var screenName:String?
    var adjustingStatusBarSizeToView:Bool = false
    
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
        
        if let tabBarItems = UITabBar.appearance().items {
            for item in tabBarItems as [UITabBarItem] {
                var imgName = ""
                switch item.tag {
                case 1:
                    imgName = "topics"
                case 2:
                    imgName = "category"
                case 3:
                    imgName = "search"
                case 4:
                    imgName = "mypage"
                case 5:
                    imgName = "setting"
                default:
                    break
                }
                if item.image == nil {
                    let image = UIImage(named: imgName)?.imageWithRenderingMode(.AlwaysOriginal)
                    let selectedImage = UIImage(named: imgName + "_g")?.imageWithRenderingMode(.AlwaysOriginal)
                    item.image = image
                    item.selectedImage = selectedImage
                } else {
                    break
                }
            }
        }
        
        if let navController = self.navigationController? {
            
            if navController.viewControllers.count > 1 {
                
                // 戻るボタン
                self.navigationItem.leftBarButtonItem = BackBarButtonItem(delegate: self)
                
                // 戻るジェスチャー
                let swipeRightGesture = UISwipeGestureRecognizer(target:self, action:Selector("pop"))
                swipeRightGesture.direction = .Right
                self.view.addGestureRecognizer(swipeRightGesture)
                
            }
        }
    }
    
    func pop() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
    adjust view size w/ Status bar size.
    */
    override func viewWillAppear(animated: Bool) {
        self.navBarColor = kNavBarColor
        if((UIApplication.sharedApplication().statusBarFrame.size.height > 20) ^ adjustingStatusBarSizeToView){
            if adjustingStatusBarSizeToView {
                statusBarSizeFix(20.0)
            } else {
                statusBarSizeFix(-20.0)
            }
            adjustingStatusBarSizeToView = !adjustingStatusBarSizeToView
        }
    }
    
    func statusBarSizeFix(amount:CGFloat){
        
    }
    
    override func viewDidAppear(animated: Bool) {
        trackScreen()
    }
    
    /**
    Send screen view event to Google Analytics.
    */
    func trackScreen(){
        screenName = (screenName != nil) ? screenName : reflect(self).summary
        let build = GAIDictionaryBuilder.createAppView().set(screenName, forKey: kGAIScreenName).build()
        GAI.sharedInstance().defaultTracker.send(build)
    }
    
    /**
    Send load time to Google Analytics
    */
    func trackTiming(category:String = "Network", loadTime:NSNumber, name:String = "fetch", label:String? = nil){
        let build = GAIDictionaryBuilder.createTimingWithCategory(category, interval: loadTime, name: name, label: label).build()
        GAI.sharedInstance().defaultTracker.send(build)
    }
    
    /**
    Show Loading Popup.
    */
    func startLoading(header:String="　", footer:String="読み込み中...", onlyTiming:Bool = false) {
        _appLoadStartTime = NSDate()
        if !onlyTiming {
            _appLoading = true
            if let window = UIApplication.sharedApplication().keyWindow {
                JHProgressHUD.sharedHUD.showInWindow(window, withHeader: header, andFooter: footer)
            }
        }
    }
    
    /**
    Hide Loading Popup.
    */
    func stopLoading(onlyTiming:Bool = false) -> NSTimeInterval {
        if !onlyTiming {
            _appLoading = false
            JHProgressHUD.sharedHUD.hide()
        }
        return NSDate().timeIntervalSinceDate(_appLoadStartTime)
    }
    
}