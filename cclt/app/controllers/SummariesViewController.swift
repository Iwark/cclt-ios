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

    var summaries:[Summary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summariesTableView.summariesTableViewDelegate = self
        summariesTableView.summaries = summaries
        summariesTableView.reloadData()
        
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
    
}
