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
    
    private struct Static {
        static var categories:[Category] = []
    }
    
    class var categories:[Category] {
        get { return Static.categories }
        set { Static.categories = newValue }
    }
    
    required internal init(json:JSON){
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
    }

}