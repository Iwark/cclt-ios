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

let kSummaryPartialViewMinSize = 120
let kSummaryPartialViewMinArea = 160 * 160

public struct SummaryPartialView {
    
    var x:Int
    var y:Int
    var width:Int
    var height:Int
    
    var area:Int { return width * height }
    
    init(_ x:Int, _ y:Int, _ width:Int, _ height:Int){
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    func divide() -> [SummaryPartialView] {
        
        var partialViews:[SummaryPartialView] = []
        while(partialViews.count == 0) {
            let partial = self
            if let pvs = SummaryViewModel.dividePartial(partial) {
                partialViews = pvs
            }
        }
        
        for _ in 0..<10 {
            var areaSum:UInt32 = 0
            for pv in partialViews {
                areaSum += pv.area
            }
            var next = Int(arc4random_uniform(areaSum))
            var nextIndex:Int = 0
            for (i, pv) in enumerate(partialViews) {
                if next > pv.area {
                    nextIndex = i
                } else {
                    next -= pv.area
                }
            }
            let dividedViews = SummaryViewModel.dividePartial(partialViews[nextIndex])
            
            if let dividedViews = dividedViews {
                partialViews.removeAtIndex(nextIndex)
                partialViews.extend(dividedViews)
            }
        }
        
        return partialViews
        
    }
    
}

class SummaryViewModel {
    
    /**
    Divide A View Structure to Two Views
    
    :param: SummaryPartialView to be devided
    
    :returns: Array of SummaryPartialView divided
    
    */
    class func dividePartial(partial:SummaryPartialView) -> [SummaryPartialView]? {
        
        var widthPortion = 1, heightPortion = 1
        
        // Minimum Size for Partial View
        if partial.width  < kSummaryPartialViewMinSize * 2 { widthPortion  = 0 }
        if partial.height < kSummaryPartialViewMinSize * 2 { heightPortion = 0 }
        if widthPortion == 0 && heightPortion == 0 { return nil }
        
        var partial1 = partial
        var partial2 = partial
        
        let seed = UInt32(partial.width * widthPortion + partial.height * heightPortion)
        let pos = Int(arc4random_uniform(seed))
        if pos < partial.width {
            //幅を分割
            
            let wSeed = UInt32(partial.width - kSummaryPartialViewMinSize * 2)
            let wPos = Int(arc4random_uniform(wSeed)) + kSummaryPartialViewMinSize
            
            partial1.width  = wPos
            partial2.x     += wPos
            partial2.width -= wPos
            
        } else {
            //高さを分割
            
            let hSeed = UInt32(partial.height - kSummaryPartialViewMinSize * 2)
            let hPos = Int(arc4random_uniform(hSeed)) + kSummaryPartialViewMinSize
            
            partial1.height  = hPos
            partial2.y      += hPos
            partial2.height  -= hPos
            
        }
        
        if partial1.area < kSummaryPartialViewMinArea || partial2.area < kSummaryPartialViewMinArea { return nil }
        if partial1.height > partial1.width * 3 || partial2.height > partial2.width * 3 { return nil }
        
        return([partial1, partial2])
        
    }

    
}

// MARK: - Communicate with the API

extension SummaryViewModel {
    
    /**
    Fetch summaries from API Server.
    
    :param: completionHandler The completion handler.
    
    */
    class func fetchAll(completionHandler: (NSError?) -> ()) {
        Alamofire.request(CcltRoute.GetSummaries()).response {
            (request, response, data, error) in
            
            if response == nil || response!.statusCode != 200 || error != nil {
                completionHandler(error)
                return
            }
            
            if let json = data as? NSData {
                let results = JSON(data: json)
                var temp:[Summary] = []
                for result:JSON in results.array! {
                    temp.append(Summary(json:result))
                }
                Summary.all = temp
                completionHandler(nil)
            }
        }
    }
    
    /**
    Fetch summary from Local || API Server.
    
    :param: id The ID of summary.
    :param: completionHandler The completion handler.
    
    */
    class func find(id: Int, completionHandler: (Summary?, NSError?) -> Void) {
        for summary in Summary.all {
            if summary.id == id {
                completionHandler(summary, nil)
                return
            }
        }
        println("summary not found on local... trying to fetch.")
        self.fetchOne(id, completionHandler)
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
}