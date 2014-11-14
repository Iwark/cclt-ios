//
//  CategoriesCollectionView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/7/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class CategoriesTableView: UITableView,
UITableViewDataSource, UITableViewDelegate {

    let kCellID = "CategoriesTableViewCell"
    let kCellNib = UINib(nibName: "CategoriesTableViewCell", bundle: nil)
    
    let kRowHeight:CGFloat = 44
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
        
        self.registerNib(kCellNib, forCellReuseIdentifier: kCellID)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Category.all.count + Feature.all.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kCellID, forIndexPath: indexPath) as CategoriesTableViewCell
        
        if Feature.all.count > indexPath.row {
            let feature = Feature.all[indexPath.row]
            cell.titleLabel.text = feature.title
            SwiftImageLoader.sharedLoader.imageForUrl(feature.icon_url, completionHandler: { (image, url) -> () in
                cell.imgView.image = image
            })
        }else if Category.all.count > indexPath.row - Feature.all.count {
            let category = Category.all[indexPath.row - Feature.all.count]
            cell.titleLabel.text = category.name
            SwiftImageLoader.sharedLoader.imageForUrl(category.iconURL, completionHandler: { (image, url) -> () in
                cell.imgView.image = image
            })
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kRowHeight
    }

}
