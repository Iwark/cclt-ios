//
//  SettingsScrollView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/19/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit
import MessageUI

protocol SettingsTableViewDelegate:class {
    func push(vc: UIViewController)
    func open(vc: UIViewController)
    func startLoading()
    
}

class SettingsTableView: UITableView,
UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    weak var settingsTableViewDelegate:SettingsTableViewDelegate?

    let kCellID = "SettingsTableViewCell"
    let kCellNib = UINib(nibName: "SettingsTableViewCell", bundle: nil)
    
    let kHeaderHeight:CGFloat = 44
    let kRowHeight:CGFloat = 52
    
    enum Section1:Int {
        case Review = 0
        case Facebook
        case Twitter
        case Web
    }
    
    enum Section2:Int {
        case Privacy = 0
        case Inquiry
        case Version
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
        
        self.registerNib(kCellNib, forCellReuseIdentifier: kCellID)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kCellID, forIndexPath: indexPath) as SettingsTableViewCell
        if indexPath.section == 0 {
            
            if let row = Section1(rawValue: indexPath.row) {
                switch(row) {
                case .Review:
                    cell.leftLabel.text = "レビューを書く"
                case .Facebook:
                    cell.leftLabel.text = "ショコラFacebookページ"
                case .Twitter:
                    cell.leftLabel.text = "ショコラTwitterページ"
                case .Web:
                    cell.leftLabel.text = "ショコラWebサイト"
                }
            }
        } else {
            if let row = Section2(rawValue: indexPath.row) {
                switch(row) {
                case .Privacy:
                    cell.leftLabel.text = "プライバシー"
                case .Inquiry:
                    cell.leftLabel.text = "お問い合わせ"
                case .Version:
                    cell.leftLabel.text = "バージョン情報"
                    if let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String {
                        cell.rightLabel.text = version
                    }
                }
            }
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kRowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            
            if let row = Section1(rawValue: indexPath.row) {
                switch(row) {
                case .Review:
                    return
                case .Facebook:
                    UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/cclt.jp")!)
                case .Twitter:
                    UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/chocolat_cclt")!)
                case .Web:
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://cclt.jp")!)
                }
            }
        } else {
            if let row = Section2(rawValue: indexPath.row) {
                switch(row) {
                case .Privacy:
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://cclt.jp/rules/privacy")!)
                case .Inquiry:
                    self.settingsTableViewDelegate?.startLoading()
                    let mvc = MailViewController()
                    mvc.mailComposeDelegate = self
                    self.settingsTableViewDelegate?.open(mvc)
                case .Version:
                    return
                }
            }
        }
        
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
