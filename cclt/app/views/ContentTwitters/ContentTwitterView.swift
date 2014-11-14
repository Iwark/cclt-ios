//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentTwitterView: UIView {

    let profileImgView:UIImageView?
    let nameLabel:UILabel?
    let textView:UIView?
    let imgView:UIImageView?
    
    let kProfileSize:CGFloat = 48
    let kProfileMarginH:CGFloat = 10
    let kImgMarginTop:CGFloat = 10
    
    init(width: CGFloat, content: ContentTwitter, completion:()->()){
        super.init()
        
        self.profileImgView = UIImageView(frame: CGRectMake(kProfileMarginH, 0, kProfileSize, kProfileSize))
        self.addSubview(profileImgView!)
        
        SwiftImageLoader.sharedLoader.imageForUrl(content.profileImageURL, completionHandler:{
            [unowned self] (image: UIImage?, url: String) in
            if let image = image {
                self.profileImgView!.image = image
            }
        })
        
        self.nameLabel = UILabel(frame: CGRectMake(kProfileSize + kProfileMarginH * 2, 0, width - kProfileSize - kProfileMarginH * 2, kProfileSize))
        self.nameLabel!.text = content.userName
        self.addSubview(nameLabel!)

        let text = content.text.stringByReplacingOccurrencesOfString("<p>", withString: "", options: nil, range: nil).stringByReplacingOccurrencesOfString("</p>", withString: "\r\n", options: nil, range: nil).stringByReplacingOccurrencesOfString("<br />", withString: "\r\n", options: nil, range: nil).stringByReplacingOccurrencesOfString("<br>", withString: "\r\n", options: nil, range: nil)
        
        self.textView = ContentsDescriptionView(width: width, description: text, type: "twitter")
        self.textView!.frame.origin.y += self.profileImgView!.frame.size.height
        self.addSubview(textView!)
        
        if content.imageURL != "" {
            
            self.imgView = UIImageView(frame: CGRectMake(0, self.textView!.frame.origin.y + self.textView!.frame.size.height + kImgMarginTop, width, width))
            self.imgView!.contentMode = UIViewContentMode.ScaleAspectFill
            
            SwiftImageLoader.sharedLoader.imageForUrl(content.imageURL, completionHandler:{
                [unowned self] (image: UIImage?, url: String) in
                if let image = image {
                    self.imgView!.image = image
                    let oldHeight = self.imgView!.frame.size.height
                    let newHeight = (self.imgView!.frame.size.width / image.size.width) * image.size.height
                    self.imgView!.frame.size.height = newHeight
                    self.frame.size.height += (newHeight - oldHeight)
                } else {
                    // TODO: 画像が見つからなかった時のデフォルト画像があればここで表示する。
                }
                completion()
            })
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
