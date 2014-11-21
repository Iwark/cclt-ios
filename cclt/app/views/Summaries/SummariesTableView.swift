//
//  SummariesTableView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/17/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

protocol SummariesTableViewDelegate:class {
    func tapped(summaryID:Int)
}

class SummariesTableView: UITableView,
UITableViewDataSource, UITableViewDelegate {
    
    weak var summariesTableViewDelegate:SummariesTableViewDelegate?
    
    let kCellID = "SummariesTableViewCell"
    let kCellNib = UINib(nibName: "SummariesTableViewCell", bundle: nil)
    
    let kRowHeight:CGFloat = 85
    
    var summaries:[Summary] = []
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
        
        self.registerNib(kCellNib, forCellReuseIdentifier: kCellID)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kCellID, forIndexPath: indexPath) as SummariesTableViewCell
        
        if summaries.count > indexPath.row {
            let summary = summaries[indexPath.row]
            cell.summaryID = summary.id
            cell.titleLabel.text = summary.title
            cell.writerLabel.text = summary.curator.name
            cell.chocoLabel.text = "\(summary.choco) choco"
            SwiftImageLoader.sharedLoader.imageForUrl(summary.icon_url, completionHandler: { (image, url) -> () in
                cell.imgView.image = image
            })
        }
        
        return cell
        
    }    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kRowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SummariesTableViewCell {
            
            if let summaryID = cell.summaryID {
            
                self.summariesTableViewDelegate?.tapped(summaryID)
            }
        }
    }
    
}
