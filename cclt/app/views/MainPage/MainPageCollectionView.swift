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
    
    let kTappedColor = UIColor("#dde", 0.8)
    let kTapEffectSeconds = 1.0
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            tappedView = touch.view
            if touch.view.tag > 0 {
                // タップ時のエフェクト
                touch.view.backgroundColor = kTappedColor
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
