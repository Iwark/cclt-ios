//
//  Summary.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/9/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Summary {
    let id: Int
    let title: String
    let choco: Int
    let approved_at: String
    let image_url: String
    let category: Category?
    
    private struct Static {
        static var summaries:[Summary] = []
    }

    class var summaries:[Summary] {
        get { return Static.summaries }
        set { Static.summaries = newValue }
    }
    
    required internal init(json:JSON){
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.choco = json["choco"].intValue
        self.approved_at = json["approved_at"].stringValue
        self.image_url = json["image_url"].stringValue
        self.category = Category.find(json["category_id"].intValue)
    }
    
    // まとめ一覧を通信で取得する
    class func fetchAll(completionHandler: (Int, [Summary]) -> Void) {
        Alamofire.request(CcltRoute.GetSummaries()).response {
            (request, response, data, error) in
            
            if let json = data as? NSData {
                let results = JSON(data: json)
                var temp:[Summary] = []
                for result:JSON in results.array! {
                    temp.append(Summary(json:result))
                }
                self.summaries = temp
                completionHandler(response!.statusCode, self.summaries)
            }
        }
    }
    
    // まとめを１件取得。ローカルに存在しなければ通信で取得する
    class func find(id: Int, completionHandler: (Int, Summary) -> Void) {
        for summary:Summary in summaries{
            if summary.id == id {
                completionHandler(200, summary)
                return
            }
        }
        println("summary not found on local... trying to fetch.")
        self.fetchOne(id, completionHandler)
    }
    
    // まとめ１件を通信で取得する
    private class func fetchOne(id: Int, completionHandler: (Int, Summary) -> Void) {
        Alamofire.request(CcltRoute.GetSummary(id)).response {
            (request, response, data, error) in
            if let json = data as? NSData {
                let result = JSON(data: json)
                let summary:Summary = Summary(json: result)
                completionHandler(response!.statusCode, summary)
            }
        }
    }
}