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
    let choco: Int
    let approved_at: String
    let image_url: String
    let category: Category?
    
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
        self.choco = json["choco"].intValue
        self.approved_at = json["approved_at"].stringValue
        self.image_url = json["image_url"].stringValue
        self.category = CategoryViewModel.find(json["category_id"].intValue)
    }
}