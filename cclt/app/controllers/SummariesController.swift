//
//  SummariesController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/9/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit
import Haneke

class SummariesController: UIViewController,
UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var summariesCollectionView: UICollectionView!
    
    let _cellID = "SummaryCell"
    let _cellNib = UINib(nibName: "SummaryCollectionViewCell", bundle: nil)
    let _sizingCell:SummaryCollectionViewCell
    
    required init(coder aDecoder: NSCoder) {
        _sizingCell = _cellNib.instantiateWithOwner(nil, options: nil)[0] as SummaryCollectionViewCell
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summariesCollectionView.delegate = self
        summariesCollectionView.dataSource = self
        
        summariesCollectionView.registerNib(_cellNib, forCellWithReuseIdentifier: _cellID)
        
        // カテゴリ取得後、ピックアップと新着記事を取得する
//        let fetchSummaries = { (completionHandler: (NSError?) -> ()) in
//            Async.parallel([SummaryViewModel.fetchPickups, SummaryViewModel.fetchAll], completionHandler)
//        }
//        Async.series( [CategoryViewModel.fetchAll, fetchSummaries] ) { (error) in
//            if let error = error {
//                println("Error: \(error)")
//            } else {
//                println("Got pickups:   \(SummaryViewModel.pickups)")
//                println("And summaries: \(SummaryViewModel.summaries)")
//            }
//        }
        
    }
    
    var waa = false
    
    override func viewDidLayoutSubviews() {
        if waa { /*return*/ }
        else{  waa = true }
        let frame = summariesCollectionView.frame
        
        println("sc:\(frame)")
        println(self.view.frame)
        
        for v in summariesCollectionView.subviews{
            (v as UIView).removeFromSuperview()
        }
        let partialView = SummaryPartialView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        
        let mainPage = MainPageViewModel(num: 0, view: partialView)
        
        for pv in mainPage.views {
            
            println(pv.frame)
            
            pv.layer.borderColor = UIColor.redColor().CGColor
            pv.layer.borderWidth = 1.0
            pv.backgroundColor = UIColor.greenColor()
            
            let area = pv.frame.size.width * pv.frame.size.height
            
            let areaLabel = UILabel(frame: CGRectMake(0, 0, pv.frame.size.width, pv.frame.size.height))
            areaLabel.text = "\(area)"
            println(area)
            
            pv.addSubview(areaLabel)
            
            if let navController = self.navigationController {
                pv.frame.origin.y -= navController.navigationBar.frame.size.height
            }
            
            summariesCollectionView.addSubview(pv)
            
        }

    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Summary.all.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(_cellID, forIndexPath: indexPath) as SummaryCollectionViewCell
        
//        let summary = SummaryViewModel.summaries[indexPath.row]
//        
//        cell.titleLabel.text = summary.title
//
//        if let image_url = NSURL(string:summary.image_url) {
//            cell.imageView.hnk_setImageFromURL(image_url)
//        }
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        println(collectionView.contentInset.left)
        let appWidth = UIScreen.mainScreen().applicationFrame.size.width
        let cellWidth = (appWidth - collectionView.contentInset.left * 3) / 2
//        return CGSize(width: cellWidth, height: cellWidth  * 0.6)
        
        return _sizingCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

