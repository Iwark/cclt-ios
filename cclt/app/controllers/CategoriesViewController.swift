//
//  CategoriesViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/3/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class CategoriesViewController: AppViewController {
    
    @IBOutlet weak var categoriesTableView: CategoriesTableView!
    
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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = "カテゴリー"
    }

}