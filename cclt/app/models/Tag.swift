//
//  Tag.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/18/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON

class Tag {
    let id: Int
    let name: String
    
    private struct Static {
        static var all:[Tag] = []
    }
    
    class var all:[Tag] {
        get { return Static.all }
        set { Static.all = newValue }
    }
    
    required internal init(json:JSON){
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
    }
    
    class func merge(tags:[Tag]){
        var allTags = Tag.all
        for t in tags {
            var found = false
            for tag in Tag.all {
                if t.id == tag.id {
                    found = true
                    break
                }
            }
            if !found {
                allTags.append(t)
            }
        }
        Tag.all = allTags
    }
}