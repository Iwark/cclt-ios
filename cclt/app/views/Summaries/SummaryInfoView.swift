//
//  SummaryInfoView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/17/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SummaryInfoView: UIView {

    let kInfoHeight:CGFloat = 80
    let kInfoPadding:CGFloat = 7
    let kCategoryWidth:CGFloat = 50
    
    let kCategoryImgMarginTop:CGFloat = 5
    let kCategoryImgWidth:CGFloat = 30
    let kCategoryImgHeight:CGFloat = 36
    let kNameLabelHeight:CGFloat = 30
    let kNameLabelPadding:CGFloat = 3
    
    let kChocoWidth:CGFloat = 80
    
    let kFooterHeight:CGFloat = 18
    let kFooterMarginBottom: CGFloat = 4
    
    init(summary: Summary, width: CGFloat) {
        super.init()
        
        self.frame = CGRectMake(0, 0, width, kInfoHeight)
        
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = Settings.Colors.infoBackgroundColor
        
        self.addSubview(bgView)

        let view = UIView(frame: self.frame)
        
        if let category = summary.category {
            view.addSubview(createCategoryView(category))
        }
        
        view.addSubview(createTitleLabel(summary.title))
        view.addSubview(createCuratorLabel(summary.curator.name))
        view.addSubview(createChocoLabel(summary.choco))
        
        bgView.addSubview(view)
        
    }
    
    func createCategoryView(category: Category) -> UIView {
        
        let view = UIView(frame: CGRectMake(0, kInfoPadding, kCategoryWidth, kInfoHeight))
        
        let imgView = DefaultImageView(frame: CGRectMake((kCategoryWidth-kCategoryImgWidth)/2, kCategoryImgMarginTop, kCategoryImgWidth, kCategoryImgHeight))
//        imgView.loadImage(category.iconURL){}
        SwiftImageLoader.sharedLoader.imageForUrl(category.iconURL, completionHandler: {
            [unowned imgView] (image, url) in
            imgView.image = image
        })
        view.addSubview(imgView)
        
        let nameLabel = UILabel(frame: CGRectMake(kNameLabelPadding, kInfoHeight - kNameLabelHeight - kInfoPadding, kCategoryWidth - kNameLabelPadding * 2, kNameLabelHeight))
        nameLabel.numberOfLines = 0
        nameLabel.text = category.name
        nameLabel.textColor = Settings.Colors.linkColor
        nameLabel.textAlignment = .Center
        nameLabel.font = Settings.Fonts.minimumFont
        view.addSubview(nameLabel)
        
        return view
    }
    
    func createTitleLabel(text: String) -> UILabel{
        
        let label = UILabel(frame: CGRectMake(kCategoryWidth + kInfoPadding * 2, 0, self.frame.size.width - kCategoryWidth - kInfoPadding * 3, kInfoHeight - kFooterHeight))
        label.textColor = Settings.Colors.textColor
        label.font = Settings.Fonts.titleFont
        label.text = text
        label.numberOfLines = 0
        label.fitToSizeByReduction()
        
        return label
    }
    
    func createCuratorLabel(name: String) -> UILabel {
        
        let label = UILabel(frame: CGRectMake(kCategoryWidth + kInfoPadding * 2, kInfoHeight - kFooterHeight, self.frame.size.width - kCategoryWidth - kInfoPadding * 2 - kChocoWidth , kFooterHeight - kFooterMarginBottom))
        label.text = name
        label.font = Settings.Fonts.smallFont
        
        return label
    }
    
    func createChocoLabel(choco: Int) -> UILabel {
        
        let label = UILabel(frame: CGRectMake(self.frame.size.width - kChocoWidth, kInfoHeight - kFooterHeight, self.frame.size.width - kCategoryWidth - kInfoPadding * 3 , kFooterHeight - kFooterMarginBottom))
        label.text = "\(choco) choco"
        label.font = Settings.Fonts.smallFont
        label.textColor = Settings.Colors.chocoColor
        return label
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
