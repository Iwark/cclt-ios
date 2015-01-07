//
//  SummariesController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/9/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit
//import Haneke

class MainPageViewController: AppViewController,
UICollectionViewDataSource, UICollectionViewDelegate, MainPageCollectionViewDelegate {
    
    @IBOutlet weak var mainPageCollectionView: MainPageCollectionView!
    let kCellID = "SummaryPartialViewCell"
    let kCellNib = UINib(nibName: "SummaryPartialViewCell", bundle: nil)
    
    let kInitialLoadNum = 3  // 最初に読み込むページの数
    
    var _page = 0
    var page:Int {
        get { return _page }
        set {
            _page = newValue
            self.screenName = "Topix_page_\(newValue + 1)"
            self.trackScreen()
        }
    }
    
    var _pages:[MainPageViewModel] = []

    var _isAddingPage = false  // 次のページを読み込み中かどうか
    var _isToAddPage  = false  // 次のページの読み込み予約
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainPageCollectionView.delegate = self
        mainPageCollectionView.mainPageCollectionViewDelegate = self
        mainPageCollectionView.dataSource = self
        
        mainPageCollectionView.registerNib(kCellNib, forCellWithReuseIdentifier: kCellID)
        
        // カテゴリ取得後、ページを読み込む
        startLoading()
        CategoryViewModel.fetchAll { (error) -> Void in
            if let error = error {
                println("category fetch error:\(error)")
            } else {
                var tasks:[((NSError?) -> ()) -> ()] = []
                for i in 0..<self.kInitialLoadNum {
                    tasks.append(self.addPage)
                }
                Async.series(tasks, completionHandler: {
                    [unowned self] (error) -> () in
                    
                    if let error = error {
                        println("error:\(error)")
                    }else{
                        self.mainPageCollectionView.reloadData()
                    }
                    
                    let interval = self.stopLoading()
                    self.trackTiming(loadTime: interval, name: "MainPage First Loading")
                    
                })
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = "トピックス"
        self.screenName = "Topix_page_\(self.page + 1)"
    }
    
    // 1度に2ページ分Fetchするようにすれば高速化の余地あり
    func addPage(callback:(NSError?) ->()){
        
        if _isAddingPage {
            _isToAddPage = true
            return
        }

        _isAddingPage = true
        startLoading(onlyTiming: true)
        
        let frame = CGRectMake(0, 0, self.mainPageCollectionView.frame.size.width, self.mainPageCollectionView.frame.size.height - 64)
        let partialView = SummaryPartialView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        let mainPage = MainPageViewModel(view: partialView)
        
        var lastSummaryID = 0
        if _pages.count > 0 {
            let lastPage = _pages[_pages.count - 1]
            if let summaryID = lastPage.partials[lastPage.partials.count-1].summary?.id {
                lastSummaryID = summaryID
                println("lastSummaryID:\(lastSummaryID)")
            }
        }
        
        mainPage.setSummaries(lastSummaryID, callback: {
            [unowned self] (error:NSError?) -> () in
            self._isAddingPage = false
            // エラーがあったら再度取得を試みる
            if let error = error {
                self.addPage(callback)
            }else{
                self._pages.append(mainPage)
                if self._isToAddPage {
                    self._isToAddPage = false
                    self.addPage(callback)
                }
                callback(nil)
                let interval = self.stopLoading()
                self.trackTiming(loadTime: interval, name: "AddingPage")
            }
        })
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _pages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellID, forIndexPath: indexPath) as SummaryPartialViewCell
        
        let frame = mainPageCollectionView.frame
        
        for sv in cell.view.subviews {
            sv.removeFromSuperview()
        }
        
        let page = indexPath.row
        
        if _pages.count > page {
            
            let mainPage = _pages[page]
            for (idx, partial) in enumerate(mainPage.partials) {
                cell.view.addSubview(partial.view)
            }
            
        } else {
            println("error")
        }
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let view = self.mainPageCollectionView.tappedView {
            if view.tag > 0 {
                view.backgroundColor = UIColor.clearColor()
            }
        }
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = Float(scrollView.contentOffset.x / pageWidth)
        let page = lroundf(fractionalPage)
        if self.page != page {
            
            self.page = page
            if _pages.count < page + kInitialLoadNum {
                self.addPage({
                    [unowned self] (error) -> () in
                    self.mainPageCollectionView.reloadData()
                })
            }
        }
    }
    
    /// 記事がタップされた時の処理(delegate from MainPageCollectionView)
    func tapped(summaryID: Int) {
        let summary = SummaryViewModel.find(summaryID, completionHandler: { (_, _) in })
        
        if let summary = summary {
            let svc = SummaryDescriptionViewController(summary: summary)
            self.navController?.pushViewController(svc, animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        
        let width = mainPageCollectionView.frame.size.width
        let height = mainPageCollectionView.frame.size.height - mainPageCollectionView.contentInset.top
        
        return CGSizeMake(width, height)
        
    }
    
    override func didReceiveMemoryWarning() {
        println("received memory warning.")
        super.didReceiveMemoryWarning()
    }


}

