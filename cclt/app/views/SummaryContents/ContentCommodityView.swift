//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentCommodityView: SummaryContentsView {
    
    let content:ContentCommodity!
    
    let titleLabel:DefaultTextLabel?
    let imgView:DefaultImageView?
    let priceLabel:DefaultTextLabel?
    let descriptionView:ContentsDescriptionView?
    let sourceLabel:SourceLabel?
    
    let kTitleMarginH:CGFloat = 10
    
    let kImgMarginLeft:CGFloat = 10
    let kImgBorderWidth:CGFloat = 1.0
    let kImgWidthPortion:CGFloat = 0.5
    
    init(width: CGFloat, content: ContentCommodity, completion: ()->()){
        super.init()
        
        self.content = content
        
        self.titleLabel = DefaultTextLabel(frame: CGRectMake(kTitleMarginH, 0, width - kTitleMarginH * 2, 0))
        self.titleLabel!.text = content.text
        self.titleLabel!.textColor = Settings.Colors.linkColor
        self.titleLabel!.sizeToFit()
        self.titleLabel!.addTapGesture(self, action: Selector("linkTapped"))
        self.addSubview(titleLabel!)
        
        var imgHeight:CGFloat = 0
        
        if content.imageURL != "" {
            self.imgView = DefaultImageView(frame: CGRectMake(kImgMarginLeft, self.titleLabel!.frame.size.height, width * kImgWidthPortion, width * kImgWidthPortion))
            self.imgView!.layer.borderWidth = kImgBorderWidth
            self.imgView!.layer.borderColor = Settings.Colors.linkColor.CGColor
            self.imgView!.contentMode = UIViewContentMode.ScaleAspectFill
            
            let tapGesture = UITapGestureRecognizer(target: self, action: "linkTapped")
            self.imgView!.addGestureRecognizer(tapGesture)
            self.imgView!.userInteractionEnabled = true
            
            if content.displaySource != "" {
                
                self.sourceLabel = SourceLabel(frame: CGRectMake(kImgMarginLeft, self.imgView!.frame.size.height + sourceLabelTopMargin, width - kImgMarginLeft * 2, sourceLabelHeight), text: content.displaySource, target: self, action: Selector("sourceTapped"))
                self.addSubview(self.sourceLabel!)
                imgHeight = self.sourceLabel!.frame.origin.y + self.sourceLabel!.frame.size.height
                
            } else {
                imgHeight = self.imgView!.frame.origin.y + self.imgView!.frame.size.height
            }
            
            
            
            
            if let imageUrl = NSURL(string: content.imageURL) {
                
                self.imgView!.startLoading()
                self.imgView!.load(imageUrl, placeholder: nil){
                    [weak self] (url, image, error) in
                    
                    if self == nil { return }
                    
                    if let image = image {
                        self!.imgView!.image = image
                        let oldHeight = self!.imgView!.frame.size.height
                        let newHeight = (self!.imgView!.frame.size.width / image.size.width) * image.size.height
                        self!.imgView!.frame.size.height = newHeight
                        if self!.sourceLabel != nil {
                            self!.sourceLabel!.frame.origin.y += (newHeight - oldHeight)
                        }
                        self!.frame.size.height += (newHeight - oldHeight)
                        self!.priceLabel!.frame.origin.y += (newHeight - oldHeight)
                        self!.descriptionView!.frame.origin.y += (newHeight - oldHeight)
                        
                        self!.imgView!.stopLoading()
                        
                    }
                    completion()
                    
                }
            }
            
            self.addSubview(imgView!)
        }
        
        self.priceLabel = DefaultTextLabel(frame: CGRectMake(kTitleMarginH, self.titleLabel!.frame.size.height + imgHeight, width - kTitleMarginH * 2, 0))
        self.priceLabel!.text = "¥\(content.price)"
        self.priceLabel!.textColor = Settings.Colors.linkColor
        self.priceLabel!.sizeToFit()
        self.priceLabel!.addTapGesture(self, action: Selector("linkTapped"))
        self.addSubview(priceLabel!)
        
        self.descriptionView = ContentsDescriptionView(width: width, description: content.text)
        self.descriptionView!.frame.origin.y += self.priceLabel!.frame.origin.y + self.priceLabel!.frame.size.height
        self.addSubview(descriptionView!)
        
        self.frame = CGRectMake(0, 0, width, self.descriptionView!.frame.origin.y + self.descriptionView!.frame.size.height)
        
        if content.imageURL == "" { completion() }
        
    }
    
    /**
    when the source is tapped
    */
    func sourceTapped(){
        if let url = NSURL(string :self.content.source){
            self.summaryContentsViewDelegate?.linkTapped(url)
        }
    }
    
    /**
    when the title or the image is tapped
    */
    func linkTapped(){
        if let url = NSURL(string :self.content.url){
            self.summaryContentsViewDelegate?.linkTapped(url)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required override init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
