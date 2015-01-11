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
}

class MainPageCollectionView: UICollectionView {

    weak var mainPageCollectionViewDelegate:MainPageCollectionViewDelegate?
    var tappedView:UIView?
    
    let kTapEffectSeconds = 1.0
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowRadius = 2.0
//        self.layer.shadowOffset = CGSizeMake(0.0, 0.0)
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).CGPath
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = UIScreen.mainScreen().scale
//    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            tappedView = touch.view
            if touch.view.tag > 0 {
                // タップ時のエフェクト
                touch.view.backgroundColor = Settings.Colors.tappedColor
                SwiftDispatch.after(kTapEffectSeconds, block: {
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
