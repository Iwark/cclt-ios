//
//  SummariesViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit


/// 記事ページの制御を行うコントローラ
class SummariesViewController: AppViewController, BackBarButtonItemDelegate {
    
    var summary: Summary?
    var summaryDescriptionView: SummaryDescriptionView?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = ""
    }
    
    init(summary:Summary) {
        super.init()
        self.summary = summary
        self.summaryDescriptionView = SummaryDescriptionView(summary: summary)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        if let sdv = self.summaryDescriptionView {
            sdv.frame = self.view.frame
            sdv.render()
            self.view.addSubview(sdv)
        }
        
        // 戻るボタン
        self.navigationItem.leftBarButtonItem = BackBarButtonItem(delegate: self)
        
        // 戻るジェスチャー
        let swipeRightGesture = UISwipeGestureRecognizer(target:self, action:Selector("pop"))
        swipeRightGesture.direction = .Right
        self.view.addGestureRecognizer(swipeRightGesture)
    }
    
    func pop() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
