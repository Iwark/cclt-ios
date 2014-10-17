//
//  Feature.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/15/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Feature {
    let id: Int
    let title: String
    let image_url: String
    let icon_url: String
    
    private struct Static {
        static var features:[Feature] = []
    }
    
    class var features:[Feature] {
        get { return Static.features }
        set { Static.features = newValue }
    }
    
    required internal init(json:JSON){
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.image_url = json["image_url"].stringValue
        self.icon_url = json["icon_url"].stringValue
    }
    
    // まとめ一覧を通信で取得する
    class func fetchAll(completionHandler: (Int, [Feature]) -> Void) {
        Alamofire.request(CcltRoute.GetFeatures()).response {
            (request, response, data, error) in
            
            if let json = data as? NSData {
                let results = JSON(data: json)
                var temp:[Feature] = []
                for result:JSON in results.array! {
                    temp.append(Feature(json:result))
                }
                self.features = temp
                completionHandler(response!.statusCode, self.features)
            }
        }
    }
    
    // まとめを１件取得。ローカルに存在しなければ通信で取得する
    class func find(id: Int, completionHandler: (Int, Feature) -> Void) {
        for feature in features{
            if feature.id == id {
                completionHandler(200, feature)
                return
            }
        }
        println("feature not found on local... trying to fetch.")
        self.fetchOne(id, completionHandler)
    }
    
    // まとめ１件を通信で取得する
    private class func fetchOne(id: Int, completionHandler: (Int, Feature) -> Void) {
        Alamofire.request(CcltRoute.GetFeature(id)).response {
            (request, response, data, error) in
            if let json = data as? NSData {
                let result = JSON(data: json)
                let summary:Feature = Feature(json: result)
                completionHandler(response!.statusCode, summary)
            }
        }
    }
}