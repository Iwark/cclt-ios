//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentImageView: SummaryContentsView {

    let content:ContentImage!
    let imgView:DefaultImageView!
    let sourceLabel:SourceLabel!
    let descriptionView:ContentsDescriptionView!
    
    let kImgMarginLeft:CGFloat    = 10
    let imgShadowLength:CGFloat   = 40.0
    let imgShadowRadius:CGFloat   = 15.0
    
    init(width: CGFloat, content: ContentImage, completion:()->()){
        super.init()
        
        self.content = content
        
        self.imgView = DefaultImageView(frame: CGRectMake(kImgMarginLeft, 0, width - kImgMarginLeft * 2, width))
        self.imgView.contentMode = UIViewContentMode.Redraw
        self.imgView.clipsToBounds = true
        
        self.descriptionView = ContentsDescriptionView(width: width, description: content.text)
        
        if content.displaySource != "" {
            
            self.sourceLabel = SourceLabel(frame: CGRectMake(kImgMarginLeft, imgView.frame.size.height + sourceLabelTopMargin, width - kImgMarginLeft * 2, sourceLabelHeight), text: content.displaySource, target: self, action: Selector("linkTapped"))
            self.addSubview(self.sourceLabel)
            
            self.descriptionView.frame.origin.y += self.sourceLabel.frame.origin.y + self.sourceLabel.frame.size.height
            
        } else {
            
            self.descriptionView.frame.origin.y += self.imgView.frame.origin.y + self.imgView.frame.size.height
            
        }
        
        self.imgView.loadImage(content.image_url, completion: {
            [weak self] () in
            
            if self == nil { return }
            
            if let image = self!.imgView.image {
                let aspectRatio = image.size.width / image.size.height
                let oldHeight = self!.imgView.frame.size.height
                let newHeight = self!.imgView.frame.size.width / aspectRatio
                if newHeight > oldHeight {
                    self!.addShadowToImageView()
                } else {
                    self!.imgView.frame.size.height = newHeight
                    self!.frame.size.height += (newHeight - oldHeight)
                    if self!.sourceLabel != nil {
                        self!.sourceLabel.frame.origin.y += (newHeight - oldHeight)
                    }
                    self!.descriptionView.frame.origin.y += (newHeight - oldHeight)
                }
            }
            completion()
        })
        
        self.addSubview(imgView)
        self.addSubview(descriptionView)
        
        self.frame = CGRectMake(0, 0, width, self.descriptionView.frame.origin.y + self.descriptionView.frame.size.height)
        
    }
    
    func linkTapped(){
        if let url = NSURL(string: content.source){
            self.summaryContentsViewDelegate?.linkTapped(url)
        }
    }

    /**
    Add shadow to the bottom of the large image.
    */
    func addShadowToImageView(){
        let subLayer = CALayer()
        subLayer.frame = self.imgView.bounds
        self.imgView.layer.addSublayer(subLayer)
        subLayer.masksToBounds = true
        let path = UIBezierPath(rect: CGRectMake(-10, subLayer.bounds.size.height-imgShadowLength, subLayer.bounds.size.width+20, imgShadowLength*2))
        subLayer.shadowOffset = CGSizeMake(2.5, 2.5)
        subLayer.shadowColor = UIColor.whiteColor().CGColor
        subLayer.shadowOpacity = 0.8
        subLayer.shadowRadius = imgShadowRadius
        subLayer.shadowPath = path.CGPath
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required override init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
