//
//  SearchScrollView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/18/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

protocol SearchTableViewDelegate:class {
    func searchWord(word: String)
    func shutdownKeyword()
}

class SearchTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    weak var searchTableViewDelegate:SearchTableViewDelegate?
    
    let kCellID = "SearchTableViewCell"
    let kRowHeight:CGFloat = 56
    
    var activeTab = 0
    var tags = [Tag]()
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activeTab == 0 {
            return tags.count
        } else {
            return SearchViewModel.histories.count
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = self.dequeueReusableCellWithIdentifier(kCellID, forIndexPath: indexPath) as UITableViewCell
        
        if activeTab == 0 {
            if tags.count > row {
                cell.textLabel?.text = tags[row].name
            }
        } else {
            let words = SearchViewModel.histories
            if words.count > row {
                cell.textLabel?.text = words[row]
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kRowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            if let textLabel = cell.textLabel {
                if let text = textLabel.text {
                    self.searchTableViewDelegate?.searchWord(text)
                }
            }
        }
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        if activeTab == 0 { return nil }
        
        // 削除
        let del = UITableViewRowAction(style: .Default, title: "Delete") {
            (action, indexPath) in
            SearchViewModel.removeSearchHistory(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        del.backgroundColor = UIColor.redColor()
        
        return [del]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        SearchViewModel.removeSearchHistory(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if activeTab == 0 {
            return .None
        } else {
            return .Delete
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.searchTableViewDelegate?.shutdownKeyword()
        super.touchesBegan(touches, withEvent: event)
    }

}
