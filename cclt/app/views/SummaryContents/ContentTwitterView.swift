//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit
import TwitterKit

class ContentTwitterView: SummaryContentsView, TWTRTweetViewDelegate {

    let profileImgView:DefaultImageView?
    let nameLabel:UILabel?
    let textView:UIView?
    let imgView:DefaultImageView?
    
    let kProfileSize:CGFloat = 48
    let kProfileMarginH:CGFloat = 10
    let kImgMarginTop:CGFloat = 10
    
    var tweetView:TWTRTweetView!
    var tweet:TWTRTweet!
    
    init(width: CGFloat, content: ContentTwitter, completion:()->()){
        super.init()
        
        if content.statusID != "" {
            Twitter.sharedInstance().logInGuestWithCompletion {
                (session: TWTRGuestSession!, error: NSError!) in
                Twitter.sharedInstance().APIClient.loadTweetWithID(content.statusID) {
                    (tweet: TWTRTweet!, error: NSError!) in
                    
                    self.tweet = tweet
                    
                    self.tweetView = TWTRTweetView(tweet: tweet, style: .Compact)
                    self.tweetView.delegate = self
                    
                    let desiredWidth = width - self.kProfileMarginH * 2
                    let desiredSize = self.tweetView.sizeThatFits(CGSizeMake(desiredWidth, CGFloat.max))
                    self.tweetView.frame = CGRectMake(self.kProfileMarginH, 0, desiredWidth, desiredSize.height)
                    
                    self.frame.size = self.tweetView.frame.size
                    self.addSubview(self.tweetView)
                    completion()
                    
                }
            }
            return
        }
        
        self.profileImgView = DefaultImageView(frame: CGRectMake(kProfileMarginH, 0, kProfileSize, kProfileSize))
        self.addSubview(profileImgView!)
        self.profileImgView!.loadImage(content.profileImageURL, indicator: true){}
        
        self.nameLabel = UILabel(frame: CGRectMake(kProfileSize + kProfileMarginH * 2, 0, width - kProfileSize - kProfileMarginH * 2, kProfileSize))
        self.nameLabel!.text = content.userName
        self.addSubview(nameLabel!)

        let text = content.text.stringByReplacingOccurrencesOfString("<p>", withString: "", options: nil, range: nil).stringByReplacingOccurrencesOfString("</p>", withString: "\r\n", options: nil, range: nil).stringByReplacingOccurrencesOfString("<br />", withString: "\r\n", options: nil, range: nil).stringByReplacingOccurrencesOfString("<br>", withString: "\r\n", options: nil, range: nil)
        
        self.textView = ContentsDescriptionView(width: width, description: text, type: "twitter")
        self.textView!.frame.origin.y += self.profileImgView!.frame.size.height
        self.addSubview(textView!)
        
        if content.imageURL != "" {
            
            self.imgView = DefaultImageView(frame: CGRectMake(0, self.textView!.frame.origin.y + self.textView!.frame.size.height + kImgMarginTop, width, width))
            self.imgView!.contentMode = UIViewContentMode.ScaleAspectFill
            
            if let imageUrl = NSURL(string: content.imageURL) {
                
                self.imgView!.startLoading()
                self.imgView!.load(imageUrl, placeholder: nil){
                    [weak self] (url, image, error) in
                    if self == nil { return }
                    if let image = image {
                        self!.imgView!.image = image
                        let oldHeight = self!.imgView!.frame.size.height
                        let newHeight = (self!.imgView!.frame.size.width / image.size.width) * image.size.height
                        self!.imgView!.frame.size.height = newHeight
                        self!.frame.size.height += (newHeight - oldHeight)
                    }
                    self!.imgView!.stopLoading()
                    completion()
                }
            }
            self.addSubview(imgView!)
            
            self.frame = CGRectMake(0, 0, width, self.imgView!.frame.origin.y + self.imgView!.frame.size.height)
            
        } else {
            
            self.frame = CGRectMake(0, 0, width, self.textView!.frame.origin.y + self.textView!.frame.size.height)
            
            completion()
            
        }
        
    }
    
    func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!) {

        let newTweetView = TWTRTweetView(tweet: tweet, style: .Regular)
        newTweetView.frame = tweetView.frame
        newTweetView.frame.size = newTweetView.sizeThatFits(CGSizeMake(tweetView.frame.size.width, CGFloat.max))
        
        self.frame.size = newTweetView.frame.size
        tweetView.removeFromSuperview()
        self.addSubview(newTweetView)
        
        self.summaryContentsViewDelegate?.layout()
    }
    
    func tweetView(tweetView: TWTRTweetView!, didTapURL url: NSURL!) {
        println("tapped!")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required override init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
