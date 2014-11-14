//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentLinkView: UIView {

    let imgView:UIImageView?
    let titleLabel:UILabel?
    let descriptionView:ContentsDescriptionView?

    let kImgMarginLeft:CGFloat = 10
    let kImgBorderWidth:CGFloat = 1.0
    let kImgWidthPortion:CGFloat = 0.5
    
    let kTitleMarginTop:CGFloat = 10
    let kTitleMarginH:CGFloat = 10
    
    init(width: CGFloat, content: ContentLink, completion: ()->()){
        super.init()
        
        var imgHeight:CGFloat = 0
        
        if content.image_url != "" {
            self.imgView = UIImageView(frame: CGRectMake(kImgMarginLeft, 0, width * kImgWidthPortion, width * kImgWidthPortion))
            self.imgView!.layer.borderWidth = kImgBorderWidth
            self.imgView!.layer.borderColor = kDefaultLinkColor.CGColor
            self.imgView!.contentMode = UIViewContentMode.ScaleAspectFill
            imgHeight = imgView!.frame.size.height
            
            SwiftImageLoader.sharedLoader.imageForUrl(content.image_url, completionHandler:{
                [unowned self] (image: UIImage?, url: String) in
                if let image = image {
                    self.imgView!.image = image
                    let oldHeight = self.imgView!.frame.size.height
                    let newHeight = (self.imgView!.frame.size.width / image.size.width) * image.size.height
                    self.imgView!.frame.size.height = newHeight
                    self.frame.size.height += (newHeight - oldHeight)
                    self.titleLabel!.frame.origin.y += (newHeight - oldHeight)
                    self.descriptionView!.frame.origin.y += (newHeight - oldHeight)
                } else {
                    // TODO: 画像が見つからなかった時のデフォルト画像があればここで表示する。
                }
                completion()
            })
            self.addSubview(imgView!)

            
        }
        
        self.descriptionView = ContentsDescriptionView(width: width, description: content.text)
        
        self.titleLabel = UILabel(frame: CGRectMake(kTitleMarginH, imgHeight + kTitleMarginTop, width - kTitleMarginH * 2, 0))
        self.titleLabel!.text = content.title
        self.titleLabel!.numberOfLines = 0
        self.titleLabel!.textColor = kDefaultLinkColor
        self.titleLabel!.sizeToFit()
        
        self.descriptionView!.frame.origin.y += self.titleLabel!.frame.origin.y + self.titleLabel!.frame.size.height
        
        self.addSubview(titleLabel!)
        self.addSubview(descriptionView!)
        
        self.frame = CGRectMake(0, 0, width, self.descriptionView!.frame.origin.y + self.descriptionView!.frame.size.height)
        
        if content.image_url == "" { completion() }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
