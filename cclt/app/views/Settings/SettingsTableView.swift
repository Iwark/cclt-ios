//
//  SettingsScrollView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/19/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

protocol SettingsTableViewDelegate:class {
    func push(vc: UIViewController)
}

class SettingsTableView: UITableView,
UITableViewDataSource, UITableViewDelegate {
    
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
                    cell.label.text = "レビューを書く"
                case .Facebook:
                    cell.label.text = "ショコラFacebookページ"
                case .Twitter:
                    cell.label.text = "ショコラTwitterページ"
                case .Web:
                    cell.label.text = "ショコラWebサイト"
                }
            }
        } else {
            if let row = Section2(rawValue: indexPath.row) {
                switch(row) {
                case .Privacy:
                    cell.label.text = "プライバシー"
                case .Inquiry:
                    cell.label.text = "お問い合わせ"
                case .Version:
                    cell.label.text = "バージョン情報"
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
        
    }
    
}
