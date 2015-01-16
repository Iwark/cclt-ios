//
//  WebViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/8/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

/// WebViewの制御を行うコントローラ
class WebViewController: AppViewController, UIWebViewDelegate {
    
    var webView: UIWebView!
    
    var _url:NSURL?
    var url:NSURL? {
        get{ return _url }
        set{
            _url = newValue
            if _url != nil {
                JHProgressHUD.sharedHUD.showInView(webView)
                webView.loadRequest(NSURLRequest(URL: _url!))
            }
        }
    }
    
    init(url: NSURL){
        super.init()
        _url = url
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = ""
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "WebView"
        
        self.webView = UIWebView(frame: self.view.frame)
        self.webView.scalesPageToFit = true
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        
        self.url = _url
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        JHProgressHUD.sharedHUD.hide()
    }
    
    override func statusBarSizeFix(amount: CGFloat) {
        self.webView.frame.origin.y += amount
    }
    
}
