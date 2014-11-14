//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentTextView: UIView {

    let kTextPaddingH:CGFloat = 10.0

    init(width: CGFloat, content: ContentText){
        super.init()
        
        let textLabel = UILabel(frame: CGRectMake(kTextPaddingH, 0, width - kTextPaddingH*2, 0))
        textLabel.numberOfLines = 0
        textLabel.text = content.text
        textLabel.font = UIFont.systemFontOfSize(kDefaultFontSize)
        textLabel.sizeToFit()
        self.addSubview(textLabel)
        
        self.frame = CGRectMake(0, 0, width, textLabel.frame.size.height)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
