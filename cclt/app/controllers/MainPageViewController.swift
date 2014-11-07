//
//  SummariesController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/9/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit
//import Haneke

class MainPageViewController: AppViewController,
UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var mainPageCollectionView: MainPageCollectionView!
    let kCellID = "SummaryPartialViewCell"
    let kCellNib = UINib(nibName: "SummaryPartialViewCell", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainPageCollectionView.delegate = self
        mainPageCollectionView.dataSource = self
        
        mainPageCollectionView.registerNib(kCellNib, forCellWithReuseIdentifier: kCellID)
        
        // カテゴリ取得後、ピックアップと新着記事を取得する
        let fetchSummaries = { (completionHandler: (NSError?) -> ()) in
            Async.parallel([SummaryViewModel.fetchAll, PickupViewModel.fetchSummaries], completionHandler)
        }
        Async.series( [CategoryViewModel.fetchAll, fetchSummaries] ) { (error) in
            if let error = error {
                println("Error: \(error)")
            } else {
                self.renderPage()
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = "トピックス"
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    func renderPage() {
        
        mainPageCollectionView.reloadData()
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Summary.all.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellID, forIndexPath: indexPath) as SummaryPartialViewCell
        
        let frame = CGRectMake(0, 0, mainPageCollectionView.frame.size.width, mainPageCollectionView.frame.size.height - 64)
        
        if Summary.all.count > 0 {
            
            if cell.view.subviews.count > 1 {
                return cell
            }
            
            for view in cell.view.subviews {
                view.removeFromSuperview()
            }
            
            let partialView = SummaryPartialView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
            let mainPage = MainPageViewModel(num: 0, view: partialView)
            
            for (idx, partial) in enumerate(mainPage.partials) {
                
                if Summary.all.count > idx {
                    partial.summary = Summary.all[idx]
                }
                let pv = partial.view
                partial.setPositionType()
                pv.render(partial)
                
                cell.view.addSubview(pv)
            }
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        
        return CGSizeMake(mainPageCollectionView.frame.size.width, mainPageCollectionView.frame.size.height - 64)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

