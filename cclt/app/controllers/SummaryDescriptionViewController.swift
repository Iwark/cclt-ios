//
//  SummaryDescriptionViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit


/// 記事ページの制御を行うコントローラ
class SummaryDescriptionViewController: AppViewController, SummaryDescriptionViewDelegate {
    
    var summary: Summary?
    var summaryDescriptionView: SummaryDescriptionView?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = ""
    }
    
    init(summary:Summary) {
        super.init()
        self.summary = summary
        self.screenName = "Summary_\(summary.id)_\(summary.title)"
        self.summaryDescriptionView = SummaryDescriptionView(summary: summary)
        self.summaryDescriptionView!.summaryDescriptionViewDelegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sdv = self.summaryDescriptionView {
            sdv.frame = self.view.frame
            sdv.frame.size.height = self.view.frame.height// - 120
            sdv.render()
            self.view.addSubview(sdv)
            
//            let actionButtonsView = ActionButtonsView(frame: CGRectMake(0, self.view.frame.size.height - 120, self.view.frame.size.width, 80), url: "http://cclt.jp/summaries/\(self.summary!.id)")
//            self.view.addSubview(actionButtonsView)
            
        }
    }
    
    func tapped(summaryID: Int) {
        self.startLoading()
        let summary = SummaryViewModel.find(summaryID) {
            [unowned self] (summary, error) in
            if let summary = summary {
                let svc = SummaryDescriptionViewController(summary: summary)
                self.navController?.pushViewController(svc, animated: true)
            }
            self.stopLoading()
        }
    }
    
    func loadMore() {
        
    }
    
}
