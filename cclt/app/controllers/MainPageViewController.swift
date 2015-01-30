//
//  SummariesController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/9/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class MainPageViewController: AppViewController,
MainPageCollectionViewDelegate, BackTopBarButtonItemDelegate, TutorialViewDelegate {
    
    @IBOutlet weak var mainPageCollectionView: MainPageCollectionView!
    var backToTopButton:BackTopBarButtonItem!
    var tutorialView:TutorialView!
    
    // 最初に読み込むページの数
    let initialLoadNum = 3
    
    // 矢印の表示時間
    let tutorialViewShowTime = 0.4
    
    // 現在のページ
    var _page = 0
    var page:Int {
        get { return _page }
        set {
            _page = newValue
            self.screenName = "Topix_page_\(newValue + 1)"
            self.trackScreen()
        }
    }

    // 読み込み状態
    var isAddingPage = false
    var isToAddPage  = false
    
    // チュートリアルの状態
    var isShowingTutorial = false
    var backToTopTutorialFinished = Settings.Tutorials.BackToTop.isFinished()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backToTopButton = BackTopBarButtonItem(delegate: self)
        
        tutorialView = TutorialView(frame: self.view.frame)
        tutorialView.delegate = self
        
        mainPageCollectionView.mainPageCollectionViewDelegate = self
        
        // カテゴリ取得後、ページを読み込む
        startLoading()
        CategoryViewModel.fetchAll { (error) -> Void in
            if let error = error {
                println("category fetch error:\(error)")
            } else {
                var tasks:[((NSError?) -> ()) -> ()] = []
                for i in 0..<self.initialLoadNum-1 {
                    tasks.append(self.addPage)
                }
                Async.series(tasks, completionHandler: {
                    [unowned self] (error) -> () in
                    
                    self.mainPageCollectionView.reloadData()
                    SwiftDispatch.after(0.2, block: { () -> () in
                        self.mainPageCollectionView.firstLoading = false
                        self.mainPageCollectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
                    })
                    self.addPage({
                        [unowned self] (error) -> () in
                        self.mainPageCollectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: MainPage.pages.count - 1, inSection: 0)])
                    })
                    
                    let interval = self.stopLoading()
//                    self.trackTiming(loadTime: interval, name: "MainPage First Loading")
                    
                })
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = "トピックス"
        self.screenName = "Topix_page_\(self.page + 1)"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // TODO: 1度に2ページ分Fetchするようにすれば高速化の余地あり
    func addPage(callback:(NSError?) ->()){
        
        if self.isAddingPage {
            self.isToAddPage = true
            return
        }
        self.isAddingPage = true

        startLoading(onlyTiming: true)
        
        let frame = CGRectMake(0, 0, self.mainPageCollectionView.frame.size.width, self.mainPageCollectionView.frame.size.height - 64)
        let partialViewModel = SummaryPartialViewModel(frame: frame)
        
        let now = NSDate()

        let divided = partialViewModel.divideToUnit()
        
        if let divided = divided {
            
            println("time took: \(NSDate().timeIntervalSinceDate(now))")
            
            MainPageViewModel.addMainPage(MainPage.lastSummaryID, partials: divided) {
                [unowned self] in
                self.isAddingPage = false
                if self.isToAddPage {
                    self.isToAddPage = false
                    self.addPage(callback)
                }
                callback(nil)
            }
        } else {
            println("serious error: dividing failed.")
        }
    }
    
    // ページ遷移
    func pageTo(page: Int) {
        
        if self.page == page { return }
        
        let prevPage = self.page
        self.page = page
        
        // TOPへ戻るボタンの表示
        if self.page >= 2 {
            self.navigationItem.leftBarButtonItem = backToTopButton
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        // 新しいページのローディング
        if MainPage.pages.count < page + self.initialLoadNum {
            self.addPage({
                [unowned self] (error) -> () in
                self.mainPageCollectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: MainPage.pages.count - 1, inSection: 0)])
            })
        }
    }
    
    // スクロール開始時
    func scrollBegan() {
        // チュートリアルの矢印を表示
        if tutorialView.superview == nil {
            if self.page == 0 && tutorialView.leftArrow.superview != nil {
                tutorialView.leftArrow.removeFromSuperview()
            }
            if self.page > 0 && tutorialView.leftArrow.superview == nil {
                tutorialView.addSubview(tutorialView.leftArrow)
            }
            self.view.addSubview(tutorialView)
            SwiftDispatch.after(tutorialViewShowTime, block: {
                [unowned self] in
                if !self.isShowingTutorial {
                    self.tutorialView.removeFromSuperview()
                }
            })
        }
    }
    
    // スクロール終了時
    func scrollEnded() {
        if self.page == 2 && !backToTopTutorialFinished {
            showBackToTopTutorial()
        }
    }
    
    // 「右へスワイプ」
    func showSwipeToNextTutorial(){
        let img = UIImage(named: "swipetonext_tutorial")!
        let tutorial = UIImageView(frame: CGRectMake(0, 0, img.size.width, img.size.height))
        tutorial.center = tutorialView.center
        tutorial.image = img
        tutorialView.addSubview(tutorial)
        tutorialView.backgroundColor = Settings.Colors.tutorialGrayColor
        tutorialView.hideArrows()
    }
    
    // TOPへ戻るチュートリアルの表示
    func showBackToTopTutorial(){
        let img = UIImage(named: "backtop_tutorial")!
        let tutorial = UIImageView(frame: CGRectMake(10.0, 66.0, img.size.width, img.size.height))
        tutorial.image = img
        tutorialView.addSubview(tutorial)
        tutorialView.backgroundColor = Settings.Colors.tutorialGrayColor
        tutorialView.hideArrows()
        self.isShowingTutorial = true
    }
    
    // チュートリアルの消去(TutorialViewDelegate)
    func hideTutorial(){
        if self.isShowingTutorial {
            self.backToTopTutorialFinished = true
            Settings.Tutorials.BackToTop.finish()
        }
        for v in tutorialView.subviews as [UIView] {
            v.removeFromSuperview()
        }
        tutorialView.showArrows()
        tutorialView.backgroundColor = Settings.Colors.tutorialLightGrayColor
        tutorialView.removeFromSuperview()
        self.isShowingTutorial = false
    }
    
    /// 記事がタップされた時の処理(delegate from MainPageCollectionView)
    func tapped(summaryID: Int) {
        let summary = SummaryViewModel.find(summaryID, completionHandler: { (_, _) in })
        
        if let summary = summary {
            let svc = SummaryDescriptionViewController(summary: summary)
            self.navController?.pushViewController(svc, animated: true)
        }
    }
    
    // TOPへ戻る
    func backToTop() {
        self.mainPageCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.allZeros, animated: true)
        if tutorialView.superview != nil {
            hideTutorial()
        }
    }
    
    override func didReceiveMemoryWarning() {
        println("received memory warning.")
        super.didReceiveMemoryWarning()
    }


}

