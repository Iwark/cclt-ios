//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentHeadlineView: UIView {
    
    let kSmallFontSize:CGFloat = 17
    let kMediumFontSize:CGFloat = 19
    let kLargeFontSize:CGFloat = 21
    
    let kRedColor = "#ff0000"
    let kGreenColor = "#00ff00"
    let kBlueColor = "#0000ff"
    
    let kTitleColor = UIColor("#232323", 1.0)
    
    let kMarginTop:CGFloat = 5
    let kMarginH: CGFloat = 10
    let kLineMarginTop:CGFloat = 2
    let kLineHeight:CGFloat = 2
    let kMarginBottom:CGFloat = 10

    init(width: CGFloat, content: ContentHeadline){
        super.init()
        
        var fontSize = kMediumFontSize
        
        switch content.fontSize {
        case .Small:
            fontSize = kSmallFontSize
        case .Medium:
            fontSize = kMediumFontSize
        case .Large:
            fontSize = kLargeFontSize
        }
        
        var lineColor = kRedColor
        
        switch content.color {
        case .Red:
            lineColor = kRedColor
        case .Green:
            lineColor = kGreenColor
        case .Blue:
            lineColor = kBlueColor
        }
        
        let titleLabel = UILabel(frame: CGRectMake(kMarginH, 0, width - kMarginH * 2, 0))
        titleLabel.text = content.text
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFontOfSize(fontSize)
        titleLabel.textColor = kTitleColor
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        
        let line = UIView(frame: CGRectMake(kMarginH, titleLabel.frame.size.height + kLineMarginTop, width - kMarginH*2, kLineHeight))
        line.backgroundColor = UIColor(lineColor, 1.0)
        self.addSubview(line)
        
        self.frame = CGRectMake(0, kMarginTop, width, line.frame.origin.y + line.frame.size.height + kMarginBottom)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
