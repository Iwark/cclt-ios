//
//  SummaryDescriptionView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

protocol SummaryDescriptionViewDelegate:class {
    func tapped(summaryID:Int)
    func linkTapped(url: NSURL)
}

class SummaryDescriptionView: UIScrollView, SummariesTableViewDelegate, SummaryContentsViewDelegate {

    weak var summaryDescriptionViewDelegate:SummaryDescriptionViewDelegate?
    let relatedSummariesView:SummariesTableView!
    let rankingSummariesView:SummariesTableView!
    let summary: Summary?
    
    let kDescPaddingH:CGFloat         = 10.0
    let kDescPaddingV:CGFloat         = 5.0
    let kContentsMarginV:CGFloat      = 10.0
    let contentsPaddingBottom:CGFloat = 20.0
    
    var infoHeight:CGFloat = 0
    let sourceLabelHeight:CGFloat = 20.0
    
    var contentsHeight:CGFloat = 0
    
    init(summary: Summary) {
        super.init()
        self.summary = summary
        self.backgroundColor = Settings.Colors.backgroundColor
        
        // 関連記事
        var relatedSummaries = [Summary]()
        for json in summary.related_summaries {
            relatedSummaries.append(Summary(json: json))
        }
        relatedSummariesView = SummariesTableView(frame: CGRectZero)
        relatedSummariesView.summaries = relatedSummaries
        relatedSummariesView.reloadData()
        relatedSummariesView.scrollEnabled = false
        relatedSummariesView.summariesTableViewDelegate = self
        
        // カテゴリランキング
        var rankingSummaries = [Summary]()
        for json in summary.category!.rankingSummaries {
            rankingSummaries.append(Summary(json: json))
        }
        rankingSummariesView = SummariesTableView(frame: CGRectZero)
        rankingSummariesView.summaries = rankingSummaries
        rankingSummariesView.reloadData()
        rankingSummariesView.scrollEnabled = false
        rankingSummariesView.summariesTableViewDelegate = self
        
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
            let mainImgView = DefaultImageView(frame: CGRectMake(0, 0, width, width))
            mainImgView.loadImage(summary.image_url, indicator: true){}
            self.addSubview(mainImgView)
            
            infoHeight += mainImgView.frame.size.height
            
            // 画像の上に乗っけるタイトルやカテゴリー等
            let infoView = SummaryInfoView(summary: summary, width: width)
            infoView.frame.origin.y = mainImgView.frame.size.height - infoView.frame.size.height
            self.addSubview(infoView)
            
            // 画像のソース
            if summary.displaySource != "" {
                let sourceLabel = DefaultTextLabel(frame: CGRectMake(kDescPaddingH, infoView.frame.origin.y - sourceLabelHeight, width - kDescPaddingH * 2, sourceLabelHeight))
                sourceLabel.text = "出典: " + summary.displaySource
                sourceLabel.font = Settings.Fonts.minimumFont
                sourceLabel.textColor = Settings.Colors.linkColor
                sourceLabel.addTapGesture(self, action: "sourceTapped")
                sourceLabel.sizeToFit()
                sourceLabel.frame.origin.x = width - sourceLabel.frame.size.width - kDescPaddingH
                self.addSubview(sourceLabel)
            }
            
            // 冒頭文
            let descLabel = UILabel(frame: CGRectMake(kDescPaddingH, infoHeight+kDescPaddingV, width - kDescPaddingH * 2, 0))
            descLabel.numberOfLines = 0
            descLabel.text = summary.description
            descLabel.font = Settings.Fonts.smallFont
            descLabel.sizeToFit()
            self.addSubview(descLabel)
            infoHeight += descLabel.frame.size.height + kDescPaddingV * 2
            
            let contentsNum = summary.contents.count
            var doneContentsNum = 0
            
            func completionHandler(){
                layout()
            }
            
            // コンテンツ
            for content in summary.contents{
                
                if let content_type = ContentType(rawValue: content["content_type"].stringValue){
                    
                    var view:SummaryContentsView?
                    
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
                        view.summaryContentsViewDelegate = self
                        view.tag = 1
                        self.addSubview(view)
                    }
                    
                }
                
            }
            
            let relatedline = ContentHeadlineView(width: self.frame.size.width, content: ContentHeadline(title:"■ 関連記事"))
            relatedline.frame.size.height -= 10.0
            relatedline.tag = 1
            self.addSubview(relatedline)
            
            relatedSummariesView.frame = CGRectMake(kDescPaddingH, 0, self.frame.size.width - kDescPaddingH * 2, 85 * 3)
            relatedSummariesView.layer.borderColor = Settings.Colors.borderLightColor
            relatedSummariesView.layer.borderWidth = 1.0
            relatedSummariesView.layer.cornerRadius = 4.0
            relatedSummariesView.tag = 1
            self.addSubview(relatedSummariesView)
            
            let curatorline = ContentHeadlineView(width: self.frame.size.width, content: ContentHeadline(title:"■ キュレータ紹介"))
            curatorline.frame.size.height -= 10.0
            curatorline.tag = 1
            self.addSubview(curatorline)
            
            let curatorView = CuratorView(frame: CGRectMake(kDescPaddingH, 0, self.frame.size.width - kDescPaddingH * 2, 0), curator: self.summary!.curator)
            curatorView.tag = 1
            self.addSubview(curatorView)
            
            let rankingline = ContentHeadlineView(width: self.frame.size.width, content: ContentHeadline(title:"■ デイリーランキング（\(summary.category!.name)）"))
            rankingline.frame.size.height -= 10.0
            rankingline.tag = 1
            self.addSubview(rankingline)
            
            rankingSummariesView.frame = CGRectMake(kDescPaddingH, 0, self.frame.size.width - kDescPaddingH * 2, 85 * 3)
            rankingSummariesView.layer.borderColor = Settings.Colors.borderLightColor
            rankingSummariesView.layer.borderWidth = 1.0
            rankingSummariesView.layer.cornerRadius = 4.0
            rankingSummariesView.tag = 1
            self.addSubview(rankingSummariesView)
            
            layout()
            
        }
        
    }
    
    func layout(){
        contentsHeight = 0
        for v in self.subviews as [UIView] {
            if v.tag != 1 { continue }
            contentsHeight += kContentsMarginV
            v.frame.origin.y = infoHeight + contentsHeight
            contentsHeight += v.frame.size.height
        }
        
        self.contentSize.height = infoHeight + contentsHeight + contentsPaddingBottom
    }
    
    func tapped(summaryID: Int) {
        self.summaryDescriptionViewDelegate?.tapped(summaryID)
    }
    
    func sourceTapped() {
        if let url = NSURL(string: summary!.source){
            linkTapped(url)
        }
    }
    
    func linkTapped(url: NSURL) {
        self.summaryDescriptionViewDelegate?.linkTapped(url)
    }
    
    func loadMore() {

    }

}