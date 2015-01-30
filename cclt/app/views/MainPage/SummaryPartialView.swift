//
//  SummaryPartialView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/29/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SummaryPartialView: UIView {
    
    init(partial: SummaryPartial) {
        super.init()
        commonInit()
        self.frame = partial.frame
        self.render(partial)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        self.layer.borderColor = Settings.Colors.borderLightColor
        self.layer.borderWidth = 0.5
    }
    
    func render(partial:SummaryPartial) {
        
        let imgView = DefaultImageView(frame: partial.imgFrame)
        imgView.loadImage(partial.imageURL, indicator: true){}
        self.addSubview(imgView)
        
        let titleLabel = UILabel(frame: partial.titleFrame)
        titleLabel.text = partial.displayTitle
        titleLabel.textColor = Settings.Colors.textColor
        titleLabel.font = Settings.Fonts.titleFont
        titleLabel.numberOfLines = 0
        titleLabel.fitToSizeByReduction(minimumSize: Settings.Fonts.titleMinimumFont.pointSize)
        
        let footerView = UIView(frame: partial.footerFrame)
        
        let curatorLabel = self.createCuratorLabel(partial.curatorName)
        
        let chocoLabel = createChocoLabel(partial.choco)
        
        footerView.addSubview(curatorLabel)
        footerView.addSubview(chocoLabel)
        
//        if curatorLabel.frame.rectByOffsetting(dx: 4, dy: 0).intersects(chocoLabel.frame) {
//            titleFrame.size.height -= kFooterHeight
//            footerView.frame.origin.y -= kFooterHeight
//            footerView.frame.size.height += kFooterHeight
//            curatorLabel.frame.origin.x = titleFrame.size.width - curatorLabel.frame.size.width
//            chocoLabel.frame.origin.y += kFooterHeight
//        }
        
//        if partial.isVerticalSmallImg() {
//            let titleLabelFitSize = titleLabel.sizeThatFits(CGSizeMake(titleLabel.frame.size.width, CGFloat.max))
//            if titleLabel.frame.size.height > titleLabelFitSize.height {
//                titleLabel.frame.size.height = titleLabelFitSize.height
//                titleLabel.frame.origin.y = footerView.frame.origin.y - titleLabel.frame.size.height - kPadding
//                let imgSize = titleLabel.frame.origin.y - kPadding * 2
//                imgView.frame.size.width = imgSize
//                imgView.frame.size.height = imgSize
//                imgView.frame.origin.x = (self.frame.size.width - imgView.frame.size.width) / 2
//            }
//        }
        
        
        
        self.addSubview(titleLabel)
        self.addSubview(footerView)
        
        self.tag = partial.summaryID
    }
    
    /// キュレータ名のラベル
    func createCuratorLabel(name:String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.textColor = Settings.Colors.curatorColor
        label.font = Settings.Fonts.minimumFont
        label.sizeToFit()
        return label
    }
    
    /// チョコ数のラベル
    func createChocoLabel(choco:Int) -> UILabel {
        let label = UILabel()
        label.text = "\(choco) choco"
        label.textColor = Settings.Colors.chocoColor
        label.font = Settings.Fonts.minimumFont
        label.sizeToFit()
        return label
    }
    
}
