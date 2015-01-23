//
//  AppDelegate.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/9/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.setupThirdpartyLibraries()
        
        self.setCuratorID()
        
        self.setUIKitAppearance()
        
        return true
    }
    
    /**
    set curator id to Curator model.
    */
    func setCuratorID(){
        let ud = NSUserDefaults.standardUserDefaults()
        if let uuid = ud.stringForKey("uuid"){
            Curator.myUUID = uuid
        } else {
            let uuid = NSUUID().UUIDString
            Curator.myUUID = uuid
            ud.setObject(uuid, forKey: "uuid")
            ud.synchronize()
        }
    }
    
    /**
    setup thirdparty libraries
    */
    func setupThirdpartyLibraries(){
        // PartyTrack
        Partytrack.sharedInstance().startWithAppID(Settings.partytrackAppID, andKey: Settings.partytrackAppKey)
        
        // JHProgressHUD
        JHProgressHUD.sharedHUD.backGroundColor = Settings.Colors.mainColor
        
        // GoogleAnalytics
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
//        GAI.sharedInstance().logger.logLevel = .Verbose
        GAI.sharedInstance().trackerWithTrackingId("UA-54309504-1")
        
        // Fabric
        Fabric.with([Crashlytics(), Twitter()])
        
        // Twitter Tweet View
        TWTRTweetView.appearance().primaryTextColor = Settings.Colors.textColor
        TWTRTweetView.appearance().backgroundColor  = Settings.Colors.twitterBackgroundColor
        TWTRTweetView.appearance().linkTextColor    = Settings.Colors.linkColor
        
    }
    
    /**
    set UI Appearence.
    */
    func setUIKitAppearance(){
        
        // show status bar.
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        
        // set UITabBar
        UITabBarItem.appearance().setTitlePositionAdjustment(UIOffsetMake(0, -2))
        UITabBar.appearance().barTintColor = Settings.Colors.tabBackgroundColor
        UITabBar.appearance().tintColor = Settings.Colors.tabTintColor
        UITabBarItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName: Settings.Colors.tabTitleColor,
            NSFontAttributeName: Settings.Fonts.tabFont!
        ], forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName: Settings.Colors.selectedTabTitleColor,
            NSFontAttributeName: Settings.Fonts.tabFont!
            ], forState: .Selected)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

