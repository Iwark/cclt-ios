//
//  DefaultUIKits.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/6/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

class DefaultTextLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        self.textColor = Settings.Colors.textColor
        self.font = Settings.Fonts.mediumFont
        self.numberOfLines = 0
    }
    
}

class DefaultImageView: UIImageView {
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        indicator.frame = self.frame
        self.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    func startLoading() {
        indicator.startAnimating()
        indicator.center = self.center
        self.addSubview(indicator)
    }
    
    func stopLoading() {
        indicator.removeFromSuperview()
    }
    
    func loadImage(url:String, completion:()->()){
        if let imageURL = NSURL(string: url) {
            self.startLoading()
            self.load(imageURL, placeholder: nil){
                [unowned self] (url, image, error) in
                if let image = image {
//                    self.image = image
                    self.stopLoading()
                }
                completion()
            }
        }
    }
    
}