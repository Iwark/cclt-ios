//
//  FeaturesCollectionView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/14/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class FeaturesCollectionView: UICollectionView,
UICollectionViewDelegate, UICollectionViewDataSource  {
    
    let kCellID = "FeaturesCollectionViewCell"
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.delegate = self
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Feature.all.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellID, forIndexPath: indexPath) as FeaturesCollectionViewCell
        
        if Feature.all.count > indexPath.row {
            
            let feature = Feature.all[indexPath.row]
            
            SwiftImageLoader.sharedLoader.imageForUrl(feature.image_url, completionHandler:{
                (image: UIImage?, url: String) in
                if let image = image {
                    cell.imgView!.image = image
                } else {
                    // TODO: 画像が見つからなかった時のデフォルト画像があればここで表示する。
                }
            })
            
            
        }
        
        return cell
        
    }
    
}
