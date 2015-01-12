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
    let image_url: String
    let introduction: String
    
    private struct Static {
        static var all:[Curator] = []
        static var myUUID:String = ""
    }
    
    class var all:[Curator] {
        get { return Static.all }
        set { Static.all = newValue }
    }
    
    class var myUUID:String {
        get { return Static.myUUID }
        set { Static.myUUID = newValue }
    }
    
    required internal init(json:JSON){
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.choco = json["choco"].intValue
        self.image_url = json["image_url"].stringValue
        self.introduction = json["introduction"].stringValue
    }
}