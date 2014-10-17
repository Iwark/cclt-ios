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
        
        Summary.fetchAll { (status, results:[Summary]) -> Void in
            self.summariesCollectionView.reloadData()
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Summary.summaries.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(_cellID, forIndexPath: indexPath) as SummaryCollectionViewCell
        
        let summary = Summary.summaries[indexPath.row]
        
        cell.titleLabel.text = summary.title
        cell.imageView.hnk_setImageFromURL(NSURL.URLWithString(summary.image_url))
        
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

