//
//  SummaryDescriptionView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SummaryDescriptionView: UIScrollView {

    let summary: Summary?
    
    let kDescPaddingH:CGFloat    = 10.0
    let kDescPaddingV:CGFloat    = 5.0
    let kContentsMarginV:CGFloat = 10.0
    
    var contentViews:[UIView] = []
    var contentHeight:CGFloat = 0
    
    init(summary: Summary) {
        super.init()
        self.summary = summary
        self.backgroundColor = Settings.Colors.backgroundColor
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func render() {
        
        if let summary = summary{
            
            let width = self.frame.size.width
            
            
            // メイン画像
            let mainImgView = UIImageView(frame: CGRectMake(0, 0, width, width))
            SwiftImageLoader.sharedLoader.imageForUrl(summary.image_url, completionHandler:{(image: UIImage?, url: String) in
                mainImgView.image = image
            })
            self.addSubview(mainImgView)
            contentHeight += mainImgView.frame.size.height
            
            // 画像の上に乗っけるタイトルやカテゴリー等
            let infoView = SummaryInfoView(summary: summary, width: width)
            infoView.frame.origin.y = mainImgView.frame.size.height - infoView.frame.size.height
            self.addSubview(infoView)
            
            // 冒頭文
            let descLabel = UILabel(frame: CGRectMake(kDescPaddingH, contentHeight+kDescPaddingV, width - kDescPaddingH * 2, 0))
            descLabel.numberOfLines = 0
            descLabel.text = summary.description
            descLabel.font = Settings.Fonts.smallFont
            descLabel.sizeToFit()
            self.addSubview(descLabel)
            contentHeight += descLabel.frame.size.height + kDescPaddingV * 2
            
            let contentsNum = summary.contents.count
            var doneContentsNum = 0
            
            func completionHandler(){
                doneContentsNum += 1
                
                if contentsNum == doneContentsNum {
                    renderingCompleted()
                }
                
            }
            
            // コンテンツ
            for content in summary.contents{
                
                if let content_type = ContentType(rawValue: content["content_type"].stringValue){
                    
                    var view:UIView?
                    
                    switch content_type{
                    case .Commodity:
                        view = ContentCommodityView(width: width, content: ContentCommodity(content), completion: completionHandler)
                    case .Headline:
                        view = ContentHeadlineView(width: width, content: ContentHeadline(content))
                        doneContentsNum++
                    case .Image:
                        view = ContentImageView(width: width, content: ContentImage(content), completion:completionHandler)
                    case .Link:
                        view = ContentLinkView(width: width, content: ContentLink(content), completion: completionHandler)
                    case .Movie:
                        view = ContentMovieView(width: width, content: ContentMovie(content))
                        doneContentsNum++
                    case .Quotation:
                        view = ContentQuotationView(width: width, content: ContentQuotation(content))
                        doneContentsNum++
                    case .Text:
                        view = ContentTextView(width: width, content: ContentText(content))
                        doneContentsNum++
                    case .Twitter:
                        view = ContentTwitterView(width: width, content: ContentTwitter(content), completion:completionHandler)

                    }
                    
                    if let view = view {
                        contentViews.append(view)
                    }
                    
                }
                
            }
            
            // コンテンツのサイズ決定
            self.contentSize = CGSizeMake(width, contentHeight)
            
            if contentsNum == doneContentsNum {
                renderingCompleted()
            }
            
        }
        
    }
    
    func renderingCompleted(){
        for view in contentViews {
            contentHeight += kContentsMarginV
            view.frame.origin.y += contentHeight
            contentHeight += view.frame.size.height
            self.addSubview(view)
        }
        self.contentSize.height = contentHeight
    }

}