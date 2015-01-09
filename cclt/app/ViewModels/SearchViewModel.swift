//
//  SearchViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/9/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class SearchViewModel {
    
    /**
    Words of search history
    */
    class var histories:[String] {
    get {
        let ud = NSUserDefaults.standardUserDefaults()
        let udHistory:AnyObject? = ud.objectForKey("searchHistory")
        
        if var history = udHistory as? [String] {
            return history
        } else {
            return [String]()
        }
    }
    }
    
    /**
    Update search history.
    */
    class func updateSearchHistory(searchWord:String) {
        let ud = NSUserDefaults.standardUserDefaults()
        let udHistory:AnyObject? = ud.objectForKey("searchHistory")
        
        if var history = udHistory?.copy() as? [String] {
            
            for (i,word) in enumerate(history) {
                print("searchWord:\(word)")
                if searchWord == word {
                    history.removeAtIndex(i)
                    break
                }
            }
            history.insert(searchWord, atIndex: 0)
            
            if history.count > Settings.maxHistorySearchWords {
                history.removeLast()
            }
            ud.setObject(history, forKey: "searchHistory")
        } else {
            ud.setObject([searchWord], forKey: "searchHistory")
        }
        
        ud.synchronize()
        
    }
    
    class func removeSearchHistory(index:Int) {
        
        let ud = NSUserDefaults.standardUserDefaults()
        let udHistory:AnyObject? = ud.objectForKey("searchHistory")
        
        if var history = udHistory?.copy() as? [String] {
            
            if index < history.count {
                history.removeAtIndex(index)
            }
            ud.setObject(history, forKey: "searchHistory")
            ud.synchronize()
        }
    }
    
}

// MARK: - Communicate with the API

extension SearchViewModel {

    /**
    Search summaries from API Server.
    
    :param: completionHandler The completion handler.
    
    */
    class func searchSummaries(q:String, page:Int, completionHandler: ([Summary]?, NSError?) -> ()) {
        
        Alamofire.request(CcltRoute.SearchSummaries(q, page)).response {
            (request, response, data, error) in
            
            if response == nil || response!.statusCode != 200 || error != nil {
                completionHandler(nil, error)
                return
            }
            
            if let json = data as? NSData {
                let results = JSON(data: json)
                var summaries:[Summary] = []
                for result:JSON in results.array! {
                    summaries.append(Summary(json:result))
                }
                Summary.merge(summaries)
                completionHandler(summaries, nil)
            }
        }
    }
}