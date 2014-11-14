//
//  SummaryPartialView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/29/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SummaryPartialView: UIView {

    let kPadding:CGFloat      = 6.0
    let kBannerPortion:CGFloat = 0.6
    
    func render(partial:SummaryPartialViewModel) {
        
        var imgFrame:CGRect   = CGRectZero
        var titleFrame:CGRect = CGRectZero
        var url:NSURL?
        let summary = partial.summary!
        
        self.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        self.layer.borderWidth = 0.5
        
        switch partial.positionType {
        case .ICON_LEFT_TEXT_RIGHT:
            imgFrame.size.width    = self.frame.size.height
            imgFrame.size.height   = self.frame.size.height
            url = NSURL(string: summary.icon_url)
            
            titleFrame.origin.x    = imgFrame.size.width - kPadding
            titleFrame.size.width  = self.frame.size.width - titleFrame.origin.x
            titleFrame.size.height = self.frame.size.height
        case .ICON_RIGHT_TEXT_LEFT:
            imgFrame.size.width    = self.frame.size.height
            imgFrame.size.height   = self.frame.size.height
            imgFrame.origin.x = self.frame.size.width - imgFrame.size.width
            url = NSURL(string: summary.icon_url)
            
            titleFrame.size.width  = imgFrame.origin.x + kPadding
            titleFrame.size.height = self.frame.size.height
        case .ICON_TOP_TEXT_BOTTOM:
            imgFrame.size.width    = self.frame.size.width
            imgFrame.size.height   = imgFrame.size.width
            url = NSURL(string: summary.icon_url)
            
            titleFrame.origin.y    = imgFrame.size.height - kPadding
            titleFrame.size.width  = self.frame.size.width
            titleFrame.size.height = self.frame.size.height - titleFrame.origin.y
        case .IMAGE_LEFT_TEXT_RIGHT:
            imgFrame.size.width    = self.frame.size.height / kBannerPortion
            imgFrame.size.height   = imgFrame.size.width * kBannerPortion
            url = NSURL(string: summary.banner_url)
            
            titleFrame.origin.x    = imgFrame.size.width - kPadding
            titleFrame.size.width  = self.frame.size.width - titleFrame.origin.x
            titleFrame.size.height = self.frame.size.height
        case .IMAGE_RIGHT_TEXT_LEFT:
            imgFrame.size.width    = self.frame.size.height / kBannerPortion
            imgFrame.size.height   = imgFrame.size.width * kBannerPortion
            imgFrame.origin.x = self.frame.size.width - imgFrame.size.width
            url = NSURL(string: summary.banner_url)
            
            titleFrame.size.width = imgFrame.origin.x + kPadding
            titleFrame.size.height = self.frame.size.height
        case .IMAGE_TOP_TEXT_BOTTOM:
            imgFrame.size.width = self.frame.size.width
            imgFrame.size.height = imgFrame.size.width * kBannerPortion
            url = NSURL(string: summary.banner_url)
            
            titleFrame.origin.y    = imgFrame.size.height - kPadding
            titleFrame.size.width  = self.frame.size.width
            titleFrame.size.height = self.frame.size.height - titleFrame.origin.y
        case .TEXT_ONLY:
            titleFrame.size = self.frame.size
        case .SMALL_ICON_LEFT_TEXT_RIGHT:
            imgFrame.size.width    = self.frame.size.height * 0.75
            imgFrame.size.height   = self.frame.size.height * 0.75
            imgFrame.origin.y      = (self.frame.size.height - imgFrame.size.height)/2
            url = NSURL(string: summary.icon_url)
            
            titleFrame.origin.x    = imgFrame.size.width - kPadding
            titleFrame.size.width  = self.frame.size.width - titleFrame.origin.x
            titleFrame.size.height = self.frame.size.height
        case .SMALL_ICON_RIGHT_TEXT_LEFT:
            imgFrame.size.width    = self.frame.size.height * 0.75
            imgFrame.size.height   = self.frame.size.height * 0.75
            imgFrame.origin.y      = (self.frame.size.height - imgFrame.size.height)/2
            imgFrame.origin.x = self.frame.size.width - imgFrame.size.width
            url = NSURL(string: summary.icon_url)
            
            titleFrame.size.width  = imgFrame.origin.x + kPadding
            titleFrame.size.height = self.frame.size.height
        case .SMALL_IMAGE_TOP_TEXT_BOTTOM:
            imgFrame.size.width  = self.frame.size.width * 0.8
            imgFrame.origin.x    = (self.frame.size.width - imgFrame.size.width)/2
            imgFrame.size.height = imgFrame.size.width * kBannerPortion
            url = NSURL(string: summary.banner_url)
            
            titleFrame.origin.y    = imgFrame.size.height - kPadding
            titleFrame.size.width  = self.frame.size.width
            titleFrame.size.height = self.frame.size.height - titleFrame.origin.y
        }
        
        if imgFrame.size.width != 0 && imgFrame.size.height != 0 {
            imgFrame.origin.x += kPadding
            imgFrame.origin.y += kPadding
            imgFrame.size.width -= kPadding * 2
            imgFrame.size.height -= kPadding * 2
            let imgView = UIImageView(frame: imgFrame)
            if let url = url {
                SwiftImageLoader.sharedLoader.imageForUrl(url.absoluteString!, completionHandler:{(image: UIImage?, url: String) in
                    imgView.image = image
                })
//                imgView.hnk_setImageFromURL(url)
            }
            self.addSubview(imgView)
        }
        
        titleFrame.origin.x += kPadding
        titleFrame.origin.y += kPadding
        titleFrame.size.width -= kPadding * 2
        titleFrame.size.height -= kPadding * 2
        let titleLabel = UILabel(frame: titleFrame)
        titleLabel.font = UIFont.systemFontOfSize(15.0)
        titleLabel.numberOfLines = 0
        if partial.positionType != .TEXT_ONLY && countElements(summary.title) > 24 {
            let startIndex = advance(summary.title.startIndex, 0)
            let endIndex = advance(startIndex, 24)
            titleLabel.text = summary.title[Range(start: startIndex, end: endIndex)] + "…"
        } else {
            titleLabel.text = summary.title
        }
        self.addSubview(titleLabel)
        
        self.tag = summary.id
    }
    
}
