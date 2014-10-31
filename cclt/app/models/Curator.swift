//
//  Curator.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/14/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON

class Curator {
    let id: Int
    let name: String
    let choco: Int
    let created_at: String
    let image_url: String
    let introduction: String
    
    private struct Static {
        static var all:[Curator] = []
    }
    
    class var all:[Curator] {
        get { return Static.all }
        set { Static.all = newValue }
    }
    
    required internal init(json:JSON){
        self.id = json["id"].intValue
        self.name = json["title"].stringValue
        self.choco = json["choco"].intValue
        self.created_at = json["approved_at"].stringValue
        self.image_url = json["image_url"].stringValue
        self.introduction = json["introduction"].stringValue
    }
}