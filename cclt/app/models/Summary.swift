//
//  Summary.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/9/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON

class Summary {
    let id: Int
    let title: String
    let shortTitle: String
    let choco: Int
    let approved_at: String
    let image_url: String
    let banner_url: String
    let icon_url: String
    let category: Category?
    let curator: Curator
    let description: String
    let source: String
    let contents: [JSON]
    let related_summaries: [JSON]
    let displaySource: String
    let displayTitle: String
    
    private struct Static {
        static var all:[Summary] = []
    }
    
    class var all:[Summary] {
        get { return Static.all }
        set { Static.all = newValue }
    }
    
    required internal init(json:JSON){
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.shortTitle = json["short_title"].stringValue
        self.choco = json["choco"].intValue
        self.approved_at = json["approved_at"].stringValue
        self.image_url = json["image_url"].stringValue
        self.banner_url = json["banner_url"].stringValue
        self.icon_url = json["icon_url"].stringValue
        self.category = CategoryViewModel.find(json["category_id"].intValue)
        self.curator = Curator(json: json["curator"])
        self.description = json["description"].stringValue
        self.source = json["source"].stringValue
        self.contents = json["summary_contents"].arrayValue
        self.related_summaries = json["related_summaries"].arrayValue
        self.displaySource = json["display_source"].stringValue
        self.displayTitle = (self.shortTitle != "") ? self.shortTitle : self.title
    }
    
    class func merge(summaries:[Summary]){
        var allSummaries = Summary.all
        for s in summaries {
            var found = false
            for summary in Summary.all {
                if s.id == summary.id {
                    found = true
                    break
                }
            }
            if !found {
                allSummaries.append(s)
            }
        }
        Summary.all = allSummaries
    }
}