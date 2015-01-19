//
//  LikeShareToolbar.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/17/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

class LikeShareToolbar: UIToolbar {
    
    let shareOnImg = UIImage(named: "btn_share_on")!
    let shareOffImg = UIImage(named: "btn_share_off")!
    
//    let favOnImg = UIImage(named: "btn_fav_on")
//    let favOffImg = UIImage(named: "btn_fav_off")
    
    var shareButton:UIButton!
    
    override init() {
        super.init()
        commonInit()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        self.tintColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        
        shareButton = UIButton.buttonWithType(.Custom) as UIButton
        
        shareButton.setImage(shareOffImg, forState: .Normal)
        shareButton.setImage(shareOnImg, forState: .Highlighted)
        
        shareButton.frame = CGRectMake(0, 0, shareOnImg.size.width, shareOnImg.size.height)
        
        let shareBarButton = UIBarButtonItem(customView: shareButton)
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedSpace.width = 8
        
        self.items = [shareBarButton, fixedSpace]
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
