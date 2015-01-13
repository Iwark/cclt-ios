//
//  MailViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/13/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit
import MessageUI

class MailViewController: MFMailComposeViewController {
   
    override init(){
        super.init()
        
        self.setToRecipients(["info@cclt.jp"])
        self.setSubject("お問い合わせ")
        
        let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")! as String
        let contents = "■ お問い合わせ内容を記入してください。\n\n" +
        "\n\n■ 端末情報\n（変更せずに送信してください。）\n" +
        "Device: \(UIDevice.currentDevice().model) \(UIDevice.currentDevice().systemVersion)\n" +
        "Version: \(version)"
        
        self.setMessageBody(contents, isHTML: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        JHProgressHUD.sharedHUD.hide()
    }
    
    override func viewDidAppear(animated: Bool) {
        let screenName = "MailViewController"
        let build = GAIDictionaryBuilder.createAppView().set(screenName, forKey: kGAIScreenName).build()
        GAI.sharedInstance().defaultTracker.send(build)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName:nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
