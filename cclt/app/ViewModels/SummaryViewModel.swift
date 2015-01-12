//
//  SummaryViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/23/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

let kDefaultFetchSummariesNum = 10

class SummaryViewModel {
    
}

// MARK: - Communicate with the API

extension SummaryViewModel {
    
    /**
    Fetch summaries from API Server.
    
    :param: completionHandler The completion handler.
    
    */
    class func fetchSummaries(categoryID:Int=0, featureID:Int=0, lastSummaryID:Int=0, num:Int=kDefaultFetchSummariesNum, completionHandler: ([Summary]?, NSError?) -> ()) {
        
        Alamofire.request(CcltRoute.GetSummaries(categoryID, featureID, lastSummaryID, num)).response {
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
    
    /**
    Fetch summary from Local || API Server.
    
    :param: id The ID of summary.
    :param: completionHandler The completion handler.
    
    */
    class func find(id: Int, completionHandler: (Summary?, NSError?) -> Void) -> Summary? {
        for summary in Summary.all {
            if summary.id == id {
                completionHandler(summary, nil)
                return summary
            }
        }
        println("summary not found on local...\(id) trying to fetch.")
        self.fetchOne(id, completionHandler)
        return nil
    }
    
    /**
    Fetch summary from API Server.
    
    :param: id The ID of summary.
    :param: completionHandler The completion handler.
    
    */
    private class func fetchOne(id: Int, completionHandler: (Summary?, NSError?) -> Void) {
        Alamofire.request(CcltRoute.GetSummary(id)).response {
            (request, response, data, error) in
            
            if response == nil || response!.statusCode != 200 || error != nil {
                completionHandler(nil, error)
                return
            }

            if let json = data as? NSData {
                let result = JSON(data: json)
                let summary:Summary = Summary(json: result)
                completionHandler(summary, nil)
            }
        }
    }
    
    /**
    Send Impression to API Server.
    
    :param: id The ID of summary.
    
    */
    class func sendImpression(id: Int) {
        let uuid = Curator.myUUID
        Alamofire.request(CcltRoute.SendImpression(id, uuid)).response {
            (request, response, data, error) in
            println(response)
            return
        }
    }
}