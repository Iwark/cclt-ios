//
//  Category.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/14/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON

class Category {
    let id: Int
    let name: String
    let iconURL: String
    let rankingSummaries: [JSON]

    private struct Static {
        static var all:[Category] = []
    }
    
    class var all:[Category] {
        get { return Static.all }
        set { Static.all = newValue }
    }
    
    required internal init(json:JSON){
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.iconURL = json["icon_url"].stringValue
        self.rankingSummaries = json["ranking_summaries"].arrayValue
    }

}