//
//  TriangleView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/9/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

class TriangleView: UIView {

    var color:UIColor
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, color:UIColor) {
        self.color = color
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {

        color.setFill()
        
        let ctx = UIGraphicsGetCurrentContext()
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        CGContextMoveToPoint(ctx, 0, 0)
        CGContextAddLineToPoint(ctx, width, 0)
        CGContextAddLineToPoint(ctx, width/2, height)
        
        CGContextFillPath(ctx)
    }
}
