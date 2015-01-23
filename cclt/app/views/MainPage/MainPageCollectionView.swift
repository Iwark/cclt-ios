//
//  MainPageCollectionView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/7/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

protocol MainPageCollectionViewDelegate:class {
    func tapped(summaryID:Int)
    func pageTo(page:Int)
    func scrollBegan()
    func scrollEnded()
}

class MainPageCollectionView: UICollectionView,
UICollectionViewDataSource, UICollectionViewDelegate {

    weak var mainPageCollectionViewDelegate:MainPageCollectionViewDelegate?
    var tappedView:UIView?
    
    let cellID = "SummaryPartialViewCell"
    let cellNib = UINib(nibName: "SummaryPartialViewCell", bundle: nil)
    let tapEffectSeconds = 1.0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        self.registerNib(cellNib, forCellWithReuseIdentifier: cellID)
        self.delegate = self
        self.dataSource = self
        
    }
    
    // セクション数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // ページ数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !Settings.Tutorials.SwipeToNext.isFinished(){
            return MainPage.pages.count + 1
        }
        return MainPage.pages.count
    }
    
    // セルサイズ
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        return CGSizeMake(self.frame.size.width, self.frame.size.height - self.contentInset.top)
    }
    
    // セルコンテンツ
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellID, forIndexPath: indexPath) as SummaryPartialViewCell
        for sv in cell.view.subviews {
            sv.removeFromSuperview()
        }
        
        let page = indexPath.row
        if MainPage.pages.count > page {
            
            var mainPage:MainPageViewModel!
            if !Settings.Tutorials.SwipeToNext.isFinished() {
                if page == 0 {
                    return cell
                } else {
                    mainPage = MainPage.pages[page-1]
                }
            } else {
                mainPage = MainPage.pages[page]
            }
            
            for (idx, partial) in enumerate(mainPage.partials) {
                cell.view.addSubview(partial.view)
            }
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.mainPageCollectionViewDelegate?.scrollBegan()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if let v = self.tappedView {
            if v.tag > 0 { v.backgroundColor = UIColor.clearColor() }
        }
        
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = Float(scrollView.contentOffset.x / pageWidth)
        let page = lroundf(fractionalPage)
        
        self.mainPageCollectionViewDelegate?.pageTo(page)
        
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.mainPageCollectionViewDelegate?.scrollEnded()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            tappedView = touch.view
            if touch.view.tag > 0 {
                // タップ時のエフェクト
                touch.view.backgroundColor = Settings.Colors.tappedColor
                SwiftDispatch.after(tapEffectSeconds, block: {
                    [unowned self] in
                    self.tappedView!.backgroundColor = UIColor.clearColor()
                })
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if let view = tappedView {
            if view.tag > 0 {
                view.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            if let view = tappedView {
                if view.tag > 0 && view.tag == touch.view.tag {
                    self.mainPageCollectionViewDelegate?.tapped(view.tag)
                }
            }
        }
    }

}
