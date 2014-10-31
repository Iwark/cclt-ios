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
        static var all:[Feature] = []
    }
    
    class var all:[Feature] {
        get { return Static.all }
        set { Static.all = newValue }
    }
    
    required internal init(json:JSON){
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.image_url = json["image_url"].stringValue
        self.icon_url = json["icon_url"].stringValue
    }
}