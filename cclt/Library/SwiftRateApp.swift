//
//  SwiftRateApp.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/12/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import Foundation

class SwiftRateApp {

    /**
    Open AppStore Review Screen
    
    :param: appStoreID the AppStoreID
    
    */
    class func rate(appStoreID:String){
        let path = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&mt=8&id=\(appStoreID)"
        if let url = NSURL(string: path){
            UIApplication.sharedApplication().openURL(url)
        }
    }
}