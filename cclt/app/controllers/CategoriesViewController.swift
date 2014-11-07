//
//  CategoriesViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/3/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class CategoriesViewController: AppViewController,
UITableViewDataSource, UITableViewDelegate {
    
    let kCellID = "CategoriesViewCell"
    let kCellNib = UINib(nibName: "CategoriesViewCell", bundle: nil)
    @IBOutlet weak var categoriesCollectionView: CategoriesCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        categoriesCollectionView.registerNib(kCellNib, forCellWithReuseIdentifier: kCellID)
        
        // カテゴリと特集ページを取得する
        let fetchSummaries = { (completionHandler: (NSError?) -> ()) in
            Async.parallel([SummaryViewModel.fetchAll, PickupViewModel.fetchSummaries], completionHandler)
        }
        Async.parallel([CategoryViewModel.fetchAll, FeatureViewModel.fetchAll], completionHandler: {
            (error) in
            
            if let error = error {
                println("Error: \(error)")
            } else {
                self.renderPage()
            }
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = "カテゴリー"
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    func renderPage() {
        
        categoriesCollectionView.reloadData()
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.all.count + Feature.all.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellID, forIndexPath: indexPath) as CategoriesViewCell
        
        if Feature.all.count > 0 {
            
            if Feature.all.count > indexPath.row {
                let feature = Feature.all[indexPath.row]
                SwiftImageLoader.sharedLoader.imageForUrl(feature.image_url, completionHandler:{(image: UIImage?, url: String) in
                    cell.imgView.image = image
                })
            }
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        
        let width:CGFloat = categoriesCollectionView.frame.size.width / 2 - 6
        
        return CGSizeMake(width, width * 0.6)
        
    }
}