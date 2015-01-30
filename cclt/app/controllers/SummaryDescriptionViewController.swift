//
//  SummaryDescriptionViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit
import Social

/// 記事ページの制御を行うコントローラ
class SummaryDescriptionViewController: AppViewController, SummaryDescriptionViewDelegate, UIActionSheetDelegate {
    
    var summary: Summary!
    var summaryDescriptionView: SummaryDescriptionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = ""
    }
    
    init(summary:Summary) {
        super.init()
        self.summary = summary
        self.screenName = "Summary_\(summary.id)_\(summary.title)"
        self.summaryDescriptionView = SummaryDescriptionView(summary: summary)
        self.summaryDescriptionView.summaryDescriptionViewDelegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SummaryViewModel.sendImpression(self.summary!.id)
        
        if let sdv = self.summaryDescriptionView {
            sdv.frame = self.view.frame
            sdv.frame.size.height = self.view.frame.height// - 120
            sdv.render()
            self.view.addSubview(sdv)
            
//            let actionButtonsView = ActionButtonsView(frame: CGRectMake(0, self.view.frame.size.height - 120, self.view.frame.size.width, 80), url: "http://cclt.jp/summaries/\(self.summary!.id)")
//            self.view.addSubview(actionButtonsView)
            
        }
        
        let toolbar = LikeShareToolbar()
        toolbar.frame = CGRectMake(0, 0, 153, 44)
        toolbar.shareButton.addTarget(self, action: Selector("share"), forControlEvents: .TouchUpInside)
//        toolbar.likeShareDelegate = self;
        self.navigationItem.rightBarButtonItems = toolbar.items
        
    }
    
    override func statusBarSizeFix(amount: CGFloat) {
        self.summaryDescriptionView.frame.origin.y += amount
    }
    
    func tapped(summaryID: Int) {
        self.startLoading()
        let summary = SummaryViewModel.find(summaryID) {
            [weak self] (summary, error) in
            if self == nil { return }
            if let summary = summary {
                let svc = SummaryDescriptionViewController(summary: summary)
                self!.navController?.pushViewController(svc, animated: true)
            }
            self!.stopLoading()
        }
    }
    
    func linkTapped(url: NSURL) {
        let urlStr = url.absoluteString!
        if let matched = urlStr.match(/"http:\\/\\/cclt\\.jp\\/summaries\\/(\\d.+)\\z"/){
            
            if matched.count > 0 {
                if let summaryID = matched[1].toInt(){
                    if summaryID > 0{
                        self.startLoading()
                        let summary = SummaryViewModel.find(summaryID) {
                            [weak self] (summary, error) in
                            if self == nil { return }
                            if let summary = summary {
                                let svc = SummaryDescriptionViewController(summary: summary)
                                self!.navController?.pushViewController(svc, animated: true)
                            }
                            self!.stopLoading()
                        }
                    }
                }
            }
            
        } else {
            let wvc = WebViewController(url: url)
            self.navigationController?.pushViewController(wvc, animated: true)
        }
    }
    
    func loadMore() {
    }
    
    /**
    Share
    */
    func share() {
        let alertTitle = "シェア"
        let message = ""
        if iOS7 {
            let actionSheet = UIActionSheet(title: alertTitle, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: "Facebook", "Twitter", "Line", "キャンセル")
            actionSheet.delegate = self
            actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1
            actionSheet.showInView(self.view)
        } else {
            let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .ActionSheet)
            
            alertController.addAction(UIAlertAction(title: "Facebook", style: .Default) {
                action in
                    self.facebookShare()
                })
            
            alertController.addAction(UIAlertAction(title: "Twitter", style: .Default) {
                [unowned self] action in
                    self.twitterShare()
                })
            
            alertController.addAction(UIAlertAction(title: "Line", style: .Default) {
                action in
                    self.lineShare()
                })
            alertController.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
            
            //For ipad And Univarsal Device
            alertController.popoverPresentationController?.sourceView = summaryDescriptionView
            alertController.popoverPresentationController?.sourceRect = CGRect(x: (summaryDescriptionView.frame.width/2), y: summaryDescriptionView.frame.height, width: 0, height: 0)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            facebookShare()
        case 1:
            twitterShare()
        case 2:
            lineShare()
        default:
            break
        }
    }
    
    func facebookShare(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            var controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            let link = "http://cclt.jp/summaries/\(self.summary.id)"
            let url = NSURL(string: link)
            controller.addURL(url)
            
            let title = self.summary.title
            controller.setInitialText(title)
            
            controller.completionHandler = {
                result in
                if result == .Done {
                    SummaryViewModel.sendShare(self.summary.id, provider: "facebook")
                    let alert = UIAlertView(title: "", message: "記事をシェアしました。", delegate: nil, cancelButtonTitle: nil)
                    alert.show()
                    SwiftDispatch.after(1.0) {
                        alert.dismissWithClickedButtonIndex(0, animated: false)
                    }
                    
                }
            }
            
            presentViewController(controller, animated: true, completion: {})
        } else {
            let alert = UIAlertView(title: "Facebookアカウントが登録されていません", message: "端末の「設定」アプリからFacebookアカウントを追加してください。", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func twitterShare(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            var controller = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            let link = "http://cclt.jp/summaries/\(self.summary.id)"
            let url = NSURL(string: link)
            controller.addURL(url)
            
            let title = self.summary.title + " @\(Settings.twitterAccount)"
            controller.setInitialText(title)
            
            controller.completionHandler = {
                result in
                if result == .Done {
                    SummaryViewModel.sendShare(self.summary.id, provider: "twitter")
                    let alert = UIAlertView(title: "", message: "記事をシェアしました。", delegate: nil, cancelButtonTitle: nil)
                    alert.show()
                    SwiftDispatch.after(1.0) {
                        alert.dismissWithClickedButtonIndex(0, animated: false)
                    }
                    
                }
            }
            
            presentViewController(controller, animated: true, completion: {})
        } else {
            let alert = UIAlertView(title: "Twitterアカウントが登録されていません", message: "端末の「設定」アプリからTwitterアカウントを追加してください。", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func lineShare(){
        
        let link = "http://cclt.jp/summaries/\(self.summary.id)"
        let title = self.summary.title
        let text = "\(title) − \(link)"
        
        let escaped = CFURLCreateStringByAddingPercentEscapes(nil, text, nil, "!*'();:@&=+$,/?%#[]", CFStringBuiltInEncodings.UTF8.rawValue)
        
        let url = NSURL(string: "line://msg/text/\(escaped)")
        
        if let url = url{
            
            if UIApplication.sharedApplication().canOpenURL(url) {
                
                SummaryViewModel.sendShare(self.summary.id, provider: "line")
                UIApplication.sharedApplication().openURL(url)
                
            } else {
                
                let alert = UIAlertView(title: "記事のシェアに失敗しました", message: "LINEのアプリが端末にインストールされているかご確認ください。", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                
            }
        }
    }
    
}
