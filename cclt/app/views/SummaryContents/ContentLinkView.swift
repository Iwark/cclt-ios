//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentLinkView: SummaryContentsView {

    let content:ContentLink!
    let imgView:DefaultImageView?
    let titleLabel:DefaultTextLabel!
    let descriptionView:ContentsDescriptionView?
    let sourceLabel:SourceLabel?

    let kImgMarginLeft:CGFloat = 10
    let kImgBorderWidth:CGFloat = 1.0
    let kImgWidthPortion:CGFloat = 0.5
    
    let kTitleMarginTop:CGFloat = 10
    let kTitleMarginH:CGFloat = 10
    
    init(width: CGFloat, content: ContentLink, completion: ()->()){
        super.init()
        
        self.content = content
        
        var imgHeight:CGFloat = 0
        
        if content.image_url != "" {
            self.imgView = DefaultImageView(frame: CGRectMake(kImgMarginLeft, 0, width * kImgWidthPortion, width * kImgWidthPortion))
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
            
            if let imageUrl = NSURL(string: content.image_url) {
                
                self.imgView!.startLoading()
                self.imgView!.load(imageUrl, placeholder: nil){
                    [weak self] (url, image, error) in
                    
                    if self == nil { return }
                    
                    if let image = image {
                        self!.imgView!.image = image
                        let oldHeight = self!.imgView!.frame.size.height
                        let newHeight = (self!.imgView!.frame.size.width / image.size.width) * image.size.height
                        self!.imgView!.frame.size.height = newHeight
                        if self!.sourceLabel != nil{
                            self!.sourceLabel!.frame.origin.y += (newHeight - oldHeight)
                        }
                        self!.frame.size.height += (newHeight - oldHeight)
                        self!.titleLabel.frame.origin.y += (newHeight - oldHeight)
                        self!.descriptionView!.frame.origin.y += (newHeight - oldHeight)
                        
                        self!.imgView!.stopLoading()
                        
                    }
                    completion()
                    
                }
            }
            self.addSubview(imgView!)

        }
        
        self.descriptionView = ContentsDescriptionView(width: width, description: content.text)
        
        self.titleLabel = DefaultTextLabel(frame: CGRectMake(kTitleMarginH, imgHeight + kTitleMarginTop, width - kTitleMarginH * 2, 0))
        self.titleLabel.text = content.title
        self.titleLabel.textColor = Settings.Colors.linkColor
        self.titleLabel.sizeToFit()
        self.titleLabel.addTapGesture(self, action: Selector("linkTapped"))
        
        self.descriptionView!.frame.origin.y += self.titleLabel!.frame.origin.y + self.titleLabel!.frame.size.height
        
        self.addSubview(titleLabel!)
        self.addSubview(descriptionView!)
        
        self.frame = CGRectMake(0, 0, width, self.descriptionView!.frame.origin.y + self.descriptionView!.frame.size.height)
        
        if content.image_url == "" { completion() }
        
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
