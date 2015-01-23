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
    func loadMore()
}

class SummariesTableView: UITableView,
UITableViewDataSource, UITableViewDelegate {
    
    weak var summariesTableViewDelegate:SummariesTableViewDelegate?
    
    let kCellID = "SummariesTableViewCell"
    let kCellNib = UINib(nibName: "SummariesTableViewCell", bundle: nil)
    
    let kRowHeight:CGFloat = 85

    var autoLoadMore = false
    var displayCellIndexToLoadMore = 5
    var loadingFinished = false
    var refreshCellHeight:CGFloat = 40.0
    var refreshCellPadding:CGFloat = 2.0
    
    var summaries:[Summary] = []
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        commonInit()        
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.delegate = self
        self.dataSource = self
        self.registerNib(kCellNib, forCellReuseIdentifier: kCellID)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (autoLoadMore && !loadingFinished ) ? summaries.count + 1 : summaries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kCellID, forIndexPath: indexPath) as SummariesTableViewCell
        
        cell.imgView.image = nil
        
        if summaries.count > indexPath.row {
            let summary = summaries[indexPath.row]
            cell.summaryID = summary.id
            cell.titleLabel.text = summary.title
            cell.writerLabel.text = summary.curator.name
            cell.chocoLabel.text = "\(summary.choco) choco"
            cell.imgView.loadImage(summary.icon_url, indicator:true){}
        } else {
            cell.imgView.image = nil
            cell.titleLabel.text = ""
            cell.writerLabel.text = ""
            cell.chocoLabel.text = ""
            let aivSize = refreshCellHeight - refreshCellPadding * 2
            let aiv = UIActivityIndicatorView(frame: CGRectMake((self.frame.size.width - aivSize)/2, refreshCellPadding, aivSize, aivSize))
            aiv.startAnimating()
            aiv.activityIndicatorViewStyle = .Gray
            cell.contentView.addSubview(aiv)
        }
        
        return cell
        
    }    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == summaries.count {
            return refreshCellHeight
        }
        
        return kRowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SummariesTableViewCell {
            if let summaryID = cell.summaryID {
                self.summariesTableViewDelegate?.tapped(summaryID)
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath.row >= summaries.count - displayCellIndexToLoadMore && !self.loadingFinished {
            self.summariesTableViewDelegate?.loadMore()
        }
        
    }
}
