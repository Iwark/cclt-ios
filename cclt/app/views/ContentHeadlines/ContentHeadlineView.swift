//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentHeadlineView: UIView {
    
    let kMarginTop:CGFloat = 5
    let kMarginH: CGFloat = 10
    let kLineMarginTop:CGFloat = 2
    let kLineHeight:CGFloat = 2
    let kMarginBottom:CGFloat = 10

    init(width: CGFloat, content: ContentHeadline){
        super.init()
        
        var font = Settings.Fonts.headlineMediumFont
        
        switch content.fontSize {
        case .Small:
            font = Settings.Fonts.headlineSmallFont
        case .Medium:
            font = Settings.Fonts.headlineMediumFont
        case .Large:
            font = Settings.Fonts.headlineLargeFont
        }
        
        var lineColor = UIColor.clearColor()
        
        switch content.color {
        case .Red:
            lineColor = Settings.Colors.headlineRedColor
        case .Green:
            lineColor = Settings.Colors.headlineGreenColor
        case .Blue:
            lineColor = Settings.Colors.headlineBlueColor
        }
        
        let titleLabel = UILabel(frame: CGRectMake(kMarginH, 0, width - kMarginH * 2, 0))
        titleLabel.text = content.text
        titleLabel.numberOfLines = 0
        titleLabel.font = font
        titleLabel.textColor = Settings.Colors.textColor
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        
        let line = UIView(frame: CGRectMake(kMarginH, titleLabel.frame.size.height + kLineMarginTop, width - kMarginH*2, kLineHeight))
        line.backgroundColor = lineColor
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
