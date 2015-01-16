//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentQuotationView: SummaryContentsView {

    let content:ContentQuotation!
    
    let kQuotationIconMarginTop:CGFloat = 8
    let kQuotationIconMarginLeft:CGFloat = 10
    let kQuotationIconWidth:CGFloat = 12
    let kTextMarginH:CGFloat = 10

    init(width: CGFloat, content: ContentQuotation){
        super.init()
        
        self.content = content
        
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
        
        if content.displaySource != "" {
            
            let sourceLabel = SourceLabel(frame: CGRectMake(kQuotationIconMarginLeft, textView.frame.size.height + sourceLabelTopMargin, width - kQuotationIconMarginLeft * 2, sourceLabelHeight), text: content.displaySource, target: self, action: Selector("sourceTapped"))
            self.addSubview(sourceLabel)
            self.frame = CGRectMake(0, 0, width, sourceLabel.frame.origin.y + sourceLabelHeight)
            
        } else {
            self.frame = CGRectMake(0, 0, width, textView.frame.origin.y + textView.frame.size.height)
        }
        
        
        
    }
    
    func sourceTapped(){
        if let url = NSURL(string: content.url){
            summaryContentsViewDelegate?.linkTapped(url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required override init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
