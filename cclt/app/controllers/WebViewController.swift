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
    
    var webView: UIWebView?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = ""
    }
    
    init(url:NSURL) {
        super.init()
        self.screenName = "WebView"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
