//
//  SummariesViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/17/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SummariesViewController: AppViewController,
SummariesTableViewDelegate {

    @IBOutlet weak var summariesTableView: SummariesTableView!

    var loadingMore  = false
    
    enum Category {
        case Feature
        case Category
    }
    var categoryID:Int    = 0
    var featureID:Int     = 0
    var searchWord:String?
    var searchPage:Int    = 1
    var summaries:[Summary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summariesTableView.summariesTableViewDelegate = self
        summariesTableView.summaries = summaries
        summariesTableView.autoLoadMore = true
        summariesTableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tapped(summaryID: Int) {
        let summary = SummaryViewModel.find(summaryID, completionHandler: { (_, _) in })
        
        if let summary = summary {
            let svc = SummaryDescriptionViewController(summary: summary)
            self.navController?.pushViewController(svc, animated: true)
        }
    }
    
    // 追加読み込み
    func loadMore() {
        if loadingMore { return }
        loadingMore = true

        let completion = {
            [weak self] (summaries:[Summary]?, error:NSError?) -> Void in
            
            if self == nil { return }
            
            if let summaries = summaries {
                if summaries.count > 0 {
                    self!.summaries.extend(summaries)
                    self!.summariesTableView.summaries = self!.summaries
                    self!.summariesTableView.beginUpdates()
                    var indexPaths = [AnyObject]()
                    for i in 0..<summaries.count {
                        indexPaths.append(NSIndexPath(forRow: self!.summaries.count-summaries.count+i, inSection: 0))
                    }
                    self!.summariesTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
                    self!.summariesTableView.endUpdates()
                } else {
                    self!.summariesTableView.loadingFinished = true
                    self!.summariesTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: self!.summaries.count-summaries.count, inSection: 0)], withRowAnimation: .Automatic)
                }
            }
            self!.loadingMore = false
        }
        
        if let searchWord = searchWord {
            searchPage++
            SearchViewModel.searchSummaries(searchWord, page: searchPage, completionHandler: completion)
        } else {
            let lastSummaryID = summaries.last!.id
            SummaryViewModel.fetchSummaries(categoryID: categoryID, featureID: featureID, lastSummaryID: lastSummaryID, completionHandler:completion)
        }
    }
}
