//
//  WebViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/8/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit
import MessageUI

/// WebViewの制御を行うコントローラ
class WebViewController: AppViewController, UIWebViewDelegate, WebMenuBarButtonItemDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate {
    
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
        
        self.navigationItem.rightBarButtonItem = WebMenuBarButtonItem(delegate: self)
    }
    
    func menuOpened() {
        let alertTitle = "メニュー"
        let message = ""
        if iOS7 {
            let actionSheet = UIActionSheet(title: alertTitle, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: "Safariで開く", "URLをコピー", "通報する", "キャンセル")
            actionSheet.delegate = self
            actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1
            actionSheet.showInView(self.view)
        } else {
            let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .ActionSheet)
            
            alertController.addAction(UIAlertAction(title: "Safariで開く", style: .Default) {
                action in
                self.openWithSafari()
                })
            
            alertController.addAction(UIAlertAction(title: "URLをコピー", style: .Default) {
                [unowned self] action in
                self.copyURL()
                })
            
            alertController.addAction(UIAlertAction(title: "通報する", style: .Default) {
                action in
                self.report()
                })
            alertController.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
            
            //For ipad And Univarsal Device
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.sourceRect = CGRect(x: (self.view.frame.width/2), y: self.view.frame.height, width: 0, height: 0)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            openWithSafari()
        case 1:
            copyURL()
        case 2:
            report()
        default:
            break
        }
    }
    
    func openWithSafari(){
        if let location = self.webView.request?.URL.absoluteString {
            if let url = NSURL(string: location) {
                println(url)
                UIApplication.sharedApplication().openURL(url)
                return
            }
        }
        println(self.url)
        UIApplication.sharedApplication().openURL(self.url!)
    }
    
    func copyURL(){
        if let location = self.webView.request?.URL.absoluteString {
            UIPasteboard.generalPasteboard().setValue(location, forPasteboardType: "public.text")
            let alert = UIAlertView(title: "", message: "URLをコピーしました。", delegate: nil, cancelButtonTitle: nil)
            alert.show()
            SwiftDispatch.after(1.0) {
                alert.dismissWithClickedButtonIndex(0, animated: false)
            }
        }
    }
    
    func report(){
        let url = (self.url != nil) ? self.url! : ""
        let location = (self.webView.request?.URL.absoluteString != nil) ? self.webView.request!.URL.absoluteString! : ""
        
        let text = (url == location) ? "URL\n\(url)" : "URL\n\(url)\n\(location)"
        let mvc = MailViewController(text: text)
        mvc.mailComposeDelegate = self
        self.presentViewController(mvc, animated: true, completion: nil)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        JHProgressHUD.sharedHUD.hide()
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func statusBarSizeFix(amount: CGFloat) {
        self.webView.frame.origin.y += amount
    }
    
}
