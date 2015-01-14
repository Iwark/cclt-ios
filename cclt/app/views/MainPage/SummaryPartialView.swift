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
    
    let kFooterHeight:CGFloat = 16.0
    let kFooterMarginBottom:CGFloat = 4.0
    
    func render(partial:SummaryPartialViewModel) {
        
        var imgFrame:CGRect   = CGRectZero
        var titleFrame:CGRect = CGRectZero
        var url:NSURL?
        let summary = partial.summary!
        
        self.layer.borderColor = Settings.Colors.borderLightColor
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
            let imgView = DefaultImageView(frame: imgFrame)
            if let url = url {
                imgView.loadImage(url.absoluteString!, indicator: true){}
            }
            self.addSubview(imgView)
        }
        
        titleFrame = titleFrame.rectByInsetting(dx: kPadding, dy: kPadding)
        titleFrame.size.height -= kFooterHeight + kFooterMarginBottom
        
        let footerView = UIView(frame: titleFrame)
        footerView.frame.origin.y = self.frame.size.height - kFooterHeight - kFooterMarginBottom
        footerView.frame.size.height = kFooterHeight
        
        let curatorLabel = UILabel(frame: CGRectZero)
        curatorLabel.text = summary.curator.name
        curatorLabel.textColor = Settings.Colors.curatorColor
        curatorLabel.font = Settings.Fonts.minimumFont
        curatorLabel.sizeToFit()
        
        let chocoLabel = UILabel(frame: CGRectZero)
        chocoLabel.text = "\(summary.choco) choco"
        chocoLabel.textColor = Settings.Colors.chocoColor
        chocoLabel.font = Settings.Fonts.minimumFont
        chocoLabel.sizeToFit()
        chocoLabel.frame.origin.x = titleFrame.size.width - chocoLabel.frame.size.width
        
        if curatorLabel.frame.rectByOffsetting(dx: 4, dy: 0).intersects(chocoLabel.frame) {
            titleFrame.size.height -= kFooterHeight
            footerView.frame.origin.y -= kFooterHeight
            footerView.frame.size.height += kFooterHeight
            curatorLabel.frame.origin.x = titleFrame.size.width - curatorLabel.frame.size.width
            chocoLabel.frame.origin.y += kFooterHeight
        }
        
        let titleLabel = UILabel(frame: titleFrame)
        titleLabel.text = summary.title
        titleLabel.textColor = Settings.Colors.textColor
        titleLabel.font = Settings.Fonts.titleFont
        titleLabel.numberOfLines = 0
        titleLabel.fitToSizeByReduction(minimumSize: Settings.Fonts.titleMinimumFont.pointSize)
        
        footerView.addSubview(curatorLabel)
        footerView.addSubview(chocoLabel)
        
        self.addSubview(titleLabel)
        self.addSubview(footerView)
        
        self.tag = summary.id
    }
    
}
