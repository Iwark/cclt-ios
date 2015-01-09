//
//  SearchViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/18/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SearchViewController: AppViewController,
UISearchBarDelegate, SearchTableViewDelegate, TopTabBarDelegate {

    @IBOutlet weak var searchTableView: SearchTableView!
    @IBOutlet weak var topTabBar: TopTabBar!
    
    let kSearchTextLengthMax = 80
    let kSegueID = "SearchToSummaries"

    let _searchBar = UISearchBar()
    var _paramSummaries:[Summary] = []
    var _paramSearchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _searchBar.backgroundColor = UIColor.clearColor()
        _searchBar.placeholder = "記事を探す"
        _searchBar.keyboardType = .Default
        _searchBar.delegate = self
        self.navigationItem.titleView = _searchBar
        
        searchTableView.searchTableViewDelegate = self
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target:self, action:Selector("swipeLeft"))
        swipeLeftGesture.direction = .Left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target:self, action:Selector("swipeRight"))
        swipeRightGesture.direction = .Right
        self.view.addGestureRecognizer(swipeRightGesture)
        
    }
    
    func swipeLeft(){
        if topTabBar.activeTab < topTabBar.titles.count - 1 {
            topTabBar.activeTab += 1
            topTabBar.layout()
            searchTableView.activeTab = topTabBar.activeTab
            searchTableView.reloadData()
        }
    }
    
    func swipeRight(){
        if topTabBar.activeTab > 0 {
            topTabBar.activeTab -= 1
            topTabBar.layout()
            searchTableView.activeTab = topTabBar.activeTab
            searchTableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topTabBar.titles = ["人気ワード", "履歴"]
        topTabBar.topTabBarDelegate = self
        topTabBar.layout()
        self.view.bringSubviewToFront(topTabBar)
        
        self.startLoading()
        TagViewModel.fetchPopularTags {
            [unowned self](tags, error) -> () in
            if let tags = tags {
                self.searchTableView.tags = tags
                self.searchTableView.reloadData()
            }
            let interval = self.stopLoading()
            self.trackTiming(loadTime: interval, name: "人気タグ")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = "さがす"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if countElements(searchText) > kSearchTextLengthMax {
            let idx = advance(searchText.startIndex, kSearchTextLengthMax)
            searchBar.text = searchText.substringToIndex(idx)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchWord(searchBar.text)
        
    }
    
    func searchWord(word: String) {
        _paramSearchText = word
        
        startLoading()
        SearchViewModel.searchSummaries(word, page: 1) {
            [unowned self](summaries, error) -> () in
            if let error = error {
                println("search error: \(error)")
            } else if let summaries = summaries {
                SearchViewModel.updateSearchHistory(word)
                self._paramSummaries = summaries
                self.performSegueWithIdentifier(self.kSegueID, sender: self)
            }
            let interval = self.stopLoading()
            self.trackTiming(loadTime: interval, name: "Search")
        }
        
    }
    
    func shutdownKeyword() {
        _searchBar.resignFirstResponder()
    }
    
    func tabChanged(){
        searchTableView.activeTab = topTabBar.activeTab
        searchTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vc = segue.destinationViewController as SummariesViewController
        vc.summaries = _paramSummaries
        vc.navTitle = _paramSearchText
        vc.screenName = "SearchResult_\(_paramSearchText)"
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
