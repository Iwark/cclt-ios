//
//  SourceLabel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/16/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

class SourceLabel: UILabel {
    
    init(frame: CGRect, text: String, target: AnyObject, action: Selector) {
        super.init(frame: frame)
        
        self.text = "出典: " + text
        self.textColor = Settings.Colors.sourceLinkColor
        self.font = Settings.Fonts.minimumFont
        
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
        self.userInteractionEnabled = true
        
        self.sizeToFit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let color = self.backgroundColor
        self.backgroundColor = Settings.Colors.tappedColor
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.2))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            () in
            self.backgroundColor = color
        }
    }
    
}