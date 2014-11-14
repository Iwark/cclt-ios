//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentImageView: UIView {

    let imgView:UIImageView?
    let descriptionView:ContentsDescriptionView?
    
    init(width: CGFloat, content: ContentImage, completion:()->()){
        super.init()
        
        self.imgView = UIImageView(frame: CGRectMake(0, 0, width, width))
        self.descriptionView = ContentsDescriptionView(width: width, description: content.text)

        self.imgView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.descriptionView!.frame.origin.y += self.imgView!.frame.size.height
        
        SwiftImageLoader.sharedLoader.imageForUrl(content.image_url, completionHandler:{
            [unowned self] (image: UIImage?, url: String) in
            if let image = image {
                self.imgView!.image = image
                let oldHeight = self.imgView!.frame.size.height
                let newHeight = (self.imgView!.frame.size.width / image.size.width) * image.size.height
                self.imgView!.frame.size.height = newHeight
                self.frame.size.height += (newHeight - oldHeight)
                self.descriptionView!.frame.origin.y += (newHeight - oldHeight)
            } else {
                // TODO: 画像が見つからなかった時のデフォルト画像があればここで表示する。
            }
            completion()
        })
        self.addSubview(imgView!)
        self.addSubview(descriptionView!)
        
        self.frame = CGRectMake(0, 0, width, self.descriptionView!.frame.origin.y + self.descriptionView!.frame.size.height)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
