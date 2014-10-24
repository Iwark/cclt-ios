//
//  Pickup.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/23/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON

class Pickup {
    let id: Int
    
    private struct Static {
        static var summaries:[Summary] = []
    }
    
    class var summaries:[Summary] {
        get { return Static.summaries }
        set { Static.summaries = newValue }
    }
    
    required internal init(json:JSON){
        self.id = json["id"].intValue
    }
}