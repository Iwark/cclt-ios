//
//  CuratorView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/22/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

class CuratorView: UIView {

    let imgView:DefaultImageView!
    let nameLabel:UILabel!
    let introductionLabel:UILabel!
    
    let cornerRadius:CGFloat = 4.0
    let imgSize:CGFloat      = 85.0
    let margin:CGFloat    = 10.0
    
    init(frame: CGRect, curator:Curator){
        super.init(frame: frame)
        
        self.imgView = DefaultImageView(frame: CGRectMake(margin, margin, imgSize, imgSize))
        self.imgView.clipsToBounds = true
        self.imgView.layer.cornerRadius = imgSize / 2
        self.imgView.loadImage(curator.image_url, indicator: true) { () in }
        
        self.nameLabel = DefaultTextLabel(frame: CGRectMake(margin*2+imgSize, margin, frame.size.width - margin*3 - imgSize, imgSize))
        self.nameLabel.text = curator.name
        self.nameLabel.font = Settings.Fonts.headlineSmallFont
        
        self.introductionLabel = DefaultTextLabel(frame: CGRectMake(margin, imgSize+margin*2, frame.size.width - margin*2, 0))
        self.introductionLabel.text = curator.introduction
        self.introductionLabel.sizeToFit()
        
        self.frame.size.height = self.introductionLabel.frame.origin.y + self.introductionLabel.frame.size.height + margin
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderColor  = Settings.Colors.borderLightColor
        self.layer.borderWidth  = 1.0
        
        self.addSubview(imgView)
        self.addSubview(nameLabel)
        self.addSubview(introductionLabel)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
