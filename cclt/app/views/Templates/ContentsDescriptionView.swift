//
//  ContentsDescription.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/12/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentsDescriptionView: UIView {
    
    let kMarginTop:CGFloat = 10.0
    let kTextMarginLeft:CGFloat = 20.0
    let kTextMarginRight:CGFloat = 10.0
    let kLineMarginLeft:CGFloat  = 12.0
    let kLineWidth:CGFloat = 2.0
    let kMarginBottom:CGFloat = 10.0
    
    let kLineColor = UIColor("#41b796", 1.0)
    let kTwitterLineColor = UIColor("#55acee", 1.0)
    
    init(width: CGFloat, description: String, type:String="text"){
        super.init()
        
        if countElements(description) < 2 { return }
        
        let textLabel = UILabel(frame: CGRectMake(kTextMarginLeft, 0, width - kTextMarginLeft - kTextMarginRight, 0))
        textLabel.numberOfLines = 0
        textLabel.text = description
        textLabel.font = UIFont.systemFontOfSize(kDefaultFontSize)
        textLabel.sizeToFit()
        self.addSubview(textLabel)
        
        let lineView = UIView(frame: CGRectMake(kLineMarginLeft, 0, kLineWidth, textLabel.frame.size.height))
        lineView.backgroundColor = kLineColor
        self.addSubview(lineView)
        
        if type == "twitter" {
            
            lineView.backgroundColor = kTwitterLineColor
            
            let twlineView = UIView(frame: CGRectMake(kLineMarginLeft, textLabel.frame.size.height - kLineWidth, width - kTextMarginLeft - kTextMarginRight, kLineWidth))
            twlineView.backgroundColor = kTwitterLineColor
            self.addSubview(twlineView)
            
        }

        self.frame = CGRectMake(0, kMarginTop, width, textLabel.frame.size.height + kMarginBottom)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}