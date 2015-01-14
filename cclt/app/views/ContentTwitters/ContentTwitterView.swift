//
//  ContentCommodityView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class ContentTwitterView: UIView, UIWebViewDelegate {

    let profileImgView:DefaultImageView?
    let nameLabel:UILabel?
    let textView:UIView?
    let imgView:DefaultImageView?
    let webView:UIWebView?
    
    let kProfileSize:CGFloat = 48
    let kProfileMarginH:CGFloat = 10
    let kImgMarginTop:CGFloat = 10
    
    var completion:(()->())?
    
    init(width: CGFloat, content: ContentTwitter, completion:()->()){
        super.init()
        
        self.completion = completion
        
        if content.html != "" {
            if let url = NSURL(string: CcltRoute.baseURLString + "content_twitters/\(content.id).html"){
                let webView = UIWebView(frame: CGRectMake(0, 0, width, 300))
                webView.backgroundColor = UIColor.clearColor()
                webView.opaque = false
                let request = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 60)
                webView.loadRequest(request)
                webView.delegate = self
                self.addSubview(webView)
                self.frame = webView.frame
                return
            }
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
                    [unowned self] (url, image, error) in
                    if let image = image {
                        self.imgView!.image = image
                        let oldHeight = self.imgView!.frame.size.height
                        let newHeight = (self.imgView!.frame.size.width / image.size.width) * image.size.height
                        self.imgView!.frame.size.height = newHeight
                        self.frame.size.height += (newHeight - oldHeight)
                    }
                    self.imgView!.stopLoading()
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
    
//    func webViewDidFinishLoad(webView: UIWebView) {
//        println("finished loading webView")
//    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlStr = request.URL.absoluteString!
        println(urlStr)
        if urlStr.hasPrefix("api-cclt://") {
            if let completion = self.completion {
                webView.sizeToFit()
                self.frame.size = webView.frame.size
                completion()
            }
            self.completion = nil
            return false
        }
        
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
