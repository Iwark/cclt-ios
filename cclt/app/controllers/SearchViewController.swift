//
//  SearchViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/18/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SearchViewController: AppViewController,
UISearchBarDelegate {

    @IBOutlet weak var searchScrollView: SearchScrollView!
    
    let kSearchTextLengthMax = 80
    let kSegueID = "SearchToSummaries"

    let _searchBar = UISearchBar()
    var _paramSummaries:[Summary] = []
    var _paramSearchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        _searchBar.backgroundColor = UIColor.clearColor()
        _searchBar.placeholder = "記事を探す"
        _searchBar.keyboardType = .Default
        _searchBar.delegate = self
        self.navigationItem.titleView = _searchBar

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navTitle = "さがす"
//        _searchBar.becomeFirstResponder()
        
        TagViewModel.fetchPopularTags {
            [unowned self](tags, error) -> () in
            if let tags = tags {
                self.searchScrollView.renderTags(tags)
            }
        }
        
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
        _paramSearchText = searchBar.text
        
        searchBar.resignFirstResponder()
        
        SummaryViewModel.searchSummaries(_paramSearchText, page: 1) {
            [unowned self](summaries, error) -> () in
            if let error = error {
                println("search error: \(error)")
            } else if let summaries = summaries {
                self._paramSummaries = summaries
                self.performSegueWithIdentifier(self.kSegueID, sender: self)
            }
        }
        
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
