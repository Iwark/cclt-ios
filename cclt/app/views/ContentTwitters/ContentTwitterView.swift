//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentTwitterView: UIView {

    let profileImgView:DefaultImageView?
    let nameLabel:UILabel?
    let textView:UIView?
    let imgView:DefaultImageView?
    
    let kProfileSize:CGFloat = 48
    let kProfileMarginH:CGFloat = 10
    let kImgMarginTop:CGFloat = 10
    
    init(width: CGFloat, content: ContentTwitter, completion:()->()){
        super.init()
        
        self.profileImgView = DefaultImageView(frame: CGRectMake(kProfileMarginH, 0, kProfileSize, kProfileSize))
        self.addSubview(profileImgView!)
        self.profileImgView!.loadImage(content.profileImageURL){}
        
        self.nameLabel = UILabel(frame: CGRectMake(kProfileSize + kProfileMarginH * 2, 0, width - kProfileSize - kProfileMarginH * 2, kProfileSize))
        self.nameLabel!.text = content.userName
        self.addSubview(nameLabel!)

        let text = content.text.stringByReplacingOccurrencesOfString("<p>", withString: "", options: nil, range: nil).stringByReplacingOccurrencesOfString("</p>", withString: "\r\n", options: nil, range: nil).stringByReplacingOccurrencesOfString("<br />", withString: "\r\n", options: nil, range: nil).stringByReplacingOccurrencesOfString("<br>", withString: "\r\n", options: nil, range: nil)
        
        self.textView = ContentsDescriptionView(width: width, description: text, type: "twitter")
        self.textView!.frame.origin.y += self.profileImgView!.frame.size.height
        self.addSubview(textView!)
        
        if content.imageURL != "" {
            
            self.imgView = DefaultImageView(frame: CGRectMake(0, self.textView!.frame.origin.y + self.textView!.frame.size.height + kImgMarginTop, width, width))
            self.imgView!.contentMode = UIViewContentMode.ScaleAspectFill
            
            if let imageUrl = NSURL(string: content.imageURL) {
                
                self.imgView!.startLoading()
                self.imgView!.load(imageUrl, placeholder: nil){
                    [unowned self] (url, image, error) in
                    if let image = image {
                        self.imgView!.image = image
                        let oldHeight = self.imgView!.frame.size.height
                        let newHeight = (self.imgView!.frame.size.width / image.size.width) * image.size.height
                        self.imgView!.frame.size.height = newHeight
                        self.frame.size.height += (newHeight - oldHeight)
                    }
                    self.imgView!.stopLoading()
                    completion()
                }
            }
            self.addSubview(imgView!)
            
            self.frame = CGRectMake(0, 0, width, self.imgView!.frame.origin.y + self.imgView!.frame.size.height)
            
        } else {
            
            self.frame = CGRectMake(0, 0, width, self.textView!.frame.origin.y + self.textView!.frame.size.height)
            
            completion()
            
        }
        
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
