//
//  CategoriesViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/3/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class CategoriesViewController: AppViewController, CategoriesTableViewDelegate {
    
    @IBOutlet weak var categoriesTableView: CategoriesTableView!
    
    let kSegueID = "CategoriesToSummaries"
    var paramSummaries:[Summary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // カテゴリと特集ページを取得する
        Async.parallel([CategoryViewModel.fetchAll, FeatureViewModel.fetchAll], completionHandler: {
            [unowned self] (error) in
            
            if let error = error {
                println("Error: \(error)")
            } else {
                self.categoriesTableView.reloadData()
            }
        })
        
        categoriesTableView.categoriesTableViewDelegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = "カテゴリー"
    }
    
    func categoryTapped(categoryID: Int) {
        SummaryViewModel.fetchSummaries(categoryID: categoryID, completionHandler:{
            [unowned self](summaries, error) -> () in
            
            if let summaries = summaries {
                
                self.paramSummaries = summaries
                self.performSegueWithIdentifier(self.kSegueID, sender: self)
                
            }
            
        })
    }
    
    func featureTapped(featureID: Int) {
        SummaryViewModel.fetchSummaries(featureID: featureID, completionHandler:{
            [unowned self](summaries, error) -> () in
            
            if let summaries = summaries {
                
                self.paramSummaries = summaries
                self.performSegueWithIdentifier(self.kSegueID, sender: self)
                
            }
            
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vc = segue.destinationViewController as SummariesViewController
        vc.summaries = self.paramSummaries
        
    }

    
    
}