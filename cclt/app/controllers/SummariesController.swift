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
    
    override func viewDidLayoutSubviews() {
        let frame = summariesCollectionView.frame
        let partialView = SummaryPartialView(0, 0, Int(frame.size.width), Int(frame.size.height))
        
        let partialViews = partialView.divide()
        
        for pv in partialViews {
            
            let view = UIView(frame: CGRectMake(CGFloat(pv.x), CGFloat(pv.y), CGFloat(pv.width), CGFloat(pv.height)))
            view.layer.borderColor = UIColor.redColor().CGColor
            view.layer.borderWidth = 1.0
            view.backgroundColor = UIColor.greenColor()
            
            summariesCollectionView.addSubview(view)
            
            println("x:\(pv.x), y:\(pv.y), w:\(pv.width), h:\(pv.height)")
            
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
    
    /**
    Divide a view to two views.
    
    :param: view The view which should be divided
    
    :returns: The two views.
    
    */
//    func divideView(view:UIView) -> [UIView] {
//        
//        
//        
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

