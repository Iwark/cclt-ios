//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentCommodityView: UIView {
    
    let titleLabel:UILabel?
    let imgView:UIImageView?
    let priceLabel:UILabel?
    let descriptionView:ContentsDescriptionView?
    
    let kTitleMarginH:CGFloat = 10
    
    let kImgMarginLeft:CGFloat = 10
    let kImgBorderWidth:CGFloat = 1.0
    let kImgWidthPortion:CGFloat = 0.5
    
    init(width: CGFloat, content: ContentCommodity, completion: ()->()){
        super.init()
        
        self.titleLabel = UILabel(frame: CGRectMake(kTitleMarginH, 0, width - kTitleMarginH * 2, 0))
        self.titleLabel!.text = content.text
        self.titleLabel!.numberOfLines = 0
        self.titleLabel!.textColor = kDefaultLinkColor
        self.titleLabel!.sizeToFit()
        self.addSubview(titleLabel!)
        
        var imgHeight:CGFloat = 0
        
        if content.imageURL != "" {
            self.imgView = UIImageView(frame: CGRectMake(kImgMarginLeft, self.titleLabel!.frame.size.height, width * kImgWidthPortion, width * kImgWidthPortion))
            self.imgView!.layer.borderWidth = kImgBorderWidth
            self.imgView!.layer.borderColor = kDefaultLinkColor.CGColor
            self.imgView!.contentMode = UIViewContentMode.ScaleAspectFill
            imgHeight = imgView!.frame.size.height
            
            SwiftImageLoader.sharedLoader.imageForUrl(content.imageURL, completionHandler:{
                [unowned self] (image: UIImage?, url: String) in
                if let image = image {
                    self.imgView!.image = image
                    let oldHeight = self.imgView!.frame.size.height
                    let newHeight = (self.imgView!.frame.size.width / image.size.width) * image.size.height
                    self.imgView!.frame.size.height = newHeight
                    self.frame.size.height += (newHeight - oldHeight)
                    self.priceLabel!.frame.origin.y += (newHeight - oldHeight)
                    self.descriptionView!.frame.origin.y += (newHeight - oldHeight)
                } else {
                    // TODO: 画像が見つからなかった時のデフォルト画像があればここで表示する。
                }
                completion()
            })
            self.addSubview(imgView!)
            
            
        }
        
        self.priceLabel = UILabel(frame: CGRectMake(kTitleMarginH, self.titleLabel!.frame.size.height + imgHeight, width - kTitleMarginH * 2, 0))
        self.priceLabel!.text = "¥\(content.price)"
        self.priceLabel!.numberOfLines = 0
        self.priceLabel!.textColor = kDefaultLinkColor
        self.priceLabel!.sizeToFit()
        self.addSubview(priceLabel!)
        
        self.descriptionView = ContentsDescriptionView(width: width, description: content.text)
        self.descriptionView!.frame.origin.y += self.priceLabel!.frame.origin.y + self.priceLabel!.frame.size.height
        self.addSubview(descriptionView!)
        
        self.frame = CGRectMake(0, 0, width, self.descriptionView!.frame.origin.y + self.descriptionView!.frame.size.height)
        
        if content.imageURL == "" { completion() }
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
