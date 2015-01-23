//
//  CategoryViewmodel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/23/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class CategoryViewModel {

}

// MARK: - Communicate with the API

extension CategoryViewModel {

    /**
    Fetch categories from API Server.
    
    :param: completionHandler The completion handler.
    
    */
    class func fetchAll(completionHandler: (NSError?) -> Void) {
        Alamofire.request(CcltRoute.GetCategories()).response {
            (request, response, data, error) in
            
            if response == nil || response!.statusCode != 200 || error != nil {
                completionHandler(error)
                return
            }
            
            if let json = data as? NSData {
                let results = JSON(data: json)
                var temp:[Category] = []
                for result:JSON in results.array! {
                    temp.append(Category(json:result))
                }
                Category.all = temp
                completionHandler(nil)
            }
        }
    }
    
    /**
    Fetch category from Local
    
    :param: id The ID of summary.
    :param: completionHandler The completion handler.
    
    */
    class func find(id: Int) -> Category? {
        for category in Category.all {
            if category.id == id {
                return category
            }
        }
        return nil
    }
    
}