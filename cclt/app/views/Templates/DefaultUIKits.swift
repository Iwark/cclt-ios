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
    
    func addTapGesture(target: AnyObject, action: Selector){
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
        self.userInteractionEnabled = true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let color = self.backgroundColor
        self.backgroundColor = Settings.Colors.tappedColor
        SwiftDispatch.after(0.2){
            () in
            self.backgroundColor = color
        }
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
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
    
    func loadImage(url:String, indicator:Bool = true, completion:()->()){
        if let imageURL = NSURL(string: url) {
            if indicator { self.startLoading() }
            self.load(imageURL, placeholder: nil){
                [weak self] (url, image, error) in
                if self == nil { return }
                if let image = image {
                    self!.image = image
                    if indicator { self!.stopLoading() }
                }
                completion()
            }
        }
    }
    
}