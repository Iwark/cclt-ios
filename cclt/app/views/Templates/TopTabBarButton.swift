//
//  TopTabBarButton.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/9/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

class TopTabBarButton: UIButton {

    var color:UIColor?
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        if let color = color {
            
            let width = self.bounds.size.width
            let height = self.bounds.size.height
            
            let bezierPath = UIBezierPath()
            bezierPath.moveToPoint(CGPointMake(0, height))
            bezierPath.addLineToPoint(CGPointMake(width, height))
            bezierPath.usesEvenOddFillRule = true
            
            color.setStroke()
            bezierPath.lineWidth = 1;
            bezierPath.stroke()
            
        }
        super.drawRect(rect)
    }
    

}
