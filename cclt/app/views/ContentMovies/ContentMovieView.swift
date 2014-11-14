//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentMovieView: UIView {
    
    let movieView:UIWebView?
    let descriptionView:UIView?
    
    let kMovieWidthPortion:CGFloat  = 0.9
    let kMovieHeightPortion:CGFloat = 0.6
    
    init(width: CGFloat, content: ContentMovie){
        super.init()
        
        let margin = (width - width * kMovieWidthPortion) / 2
        
        self.movieView = UIWebView(frame: CGRectMake(margin, 0, width * kMovieWidthPortion, width *  kMovieHeightPortion))
        if let url = NSURL(string: content.url) {
            println(url)
            self.movieView!.loadRequest(NSURLRequest(URL: url))
        }
        self.descriptionView = ContentsDescriptionView(width: width, description: content.text)
        
        self.movieView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.descriptionView!.frame.origin.y += self.movieView!.frame.size.height
        
        self.addSubview(movieView!)
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
