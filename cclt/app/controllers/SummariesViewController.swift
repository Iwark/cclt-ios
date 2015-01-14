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

        if let searchWord = searchWord {
            searchPage++
            SearchViewModel.searchSummaries(searchWord, page: searchPage) {
                [unowned self](summaries, error) -> () in
                if let error = error {
                    println("search error: \(error)")
                } else if let summaries = summaries {
                    if summaries.count > 0 {
                        self.summaries.extend(summaries)
                        self.summariesTableView.summaries = self.summaries
                    } else {
                        self.summariesTableView.loadingFinished = true
                    }
                    self.summariesTableView.reloadData()
                }
                self.loadingMore = false
            }
            return
        }
        
        var lastSummaryID = summaries.last!.id
        println("\(summaries.last!.title), \(lastSummaryID)")
        
        SummaryViewModel.fetchSummaries(categoryID: categoryID, featureID: featureID, lastSummaryID: lastSummaryID, completionHandler:{
            [unowned self](summaries, error) -> () in
            
            if let summaries = summaries {
                if summaries.count > 0 {
                    self.summaries.extend(summaries)
                    self.summariesTableView.summaries = self.summaries
                } else {
                    self.summariesTableView.loadingFinished = true
                }
                self.summariesTableView.reloadData()
            }
            self.loadingMore = false
            
        })
        
    }
}
