//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentQuotationView: UIView {

    let kQuotationIconMarginTop:CGFloat = 8
    let kQuotationIconMarginLeft:CGFloat = 10
    let kQuotationIconWidth:CGFloat = 12
    let kTextMarginH:CGFloat = 10

    init(width: CGFloat, content: ContentQuotation){
        super.init()
        
        let image   = UIImage(named: "quotation")
        let imgView = UIImageView(frame: CGRectMake(kQuotationIconMarginLeft, kQuotationIconMarginTop, kQuotationIconWidth, kQuotationIconWidth * image!.size.height / image!.size.width))
        imgView.image = image
        self.addSubview(imgView)
        
        let textX = kQuotationIconMarginLeft + kQuotationIconWidth + kTextMarginH
        
        let textView = UILabel(frame: CGRectMake(textX, 0, width - textX - kTextMarginH, 0))
        textView.text = content.text
        textView.numberOfLines = 0
        textView.font = Settings.Fonts.mediumFont
        textView.sizeToFit()
        textView.textColor = Settings.Colors.quotationColor
        self.addSubview(textView)
        
        self.frame = CGRectMake(0, 0, width, textView.frame.size.height)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
