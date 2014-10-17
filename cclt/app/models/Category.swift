//
//  Category.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/14/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import Alamofire
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
    
    class func fetchAll(completionHandler: (Int, [Category]) -> Void) {
        Alamofire.request(CcltRoute.GetCategories()).response {
            (request, response, data, error) in
            
            if let json = data as? NSData {
                let results = JSON(data: json)
                var temp:[Category] = []
                for result:JSON in results.array! {
                    temp.append(Category(json:result))
                }
                self.categories = temp
                completionHandler(response!.statusCode, self.categories)
            }
        }
    }
    
    class func find(id: Int) -> Category? {
        for category in categories{
            if category.id == id {
                return category
            }
        }
        println("category not found on local.")
        return nil
    }
}