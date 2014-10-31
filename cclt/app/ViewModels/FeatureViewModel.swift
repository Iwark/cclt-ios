//
//  FeatureViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/27/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class FeatureViewModel {
    
}

// MARK: - Communicate with the API

extension FeatureViewModel {
    
    /**
    Fetch features from API Server.
    
    :param: completionHandler The completion handler.
    
    */
    class func fetchAll(completionHandler: (NSError?) -> ()) {
        Alamofire.request(CcltRoute.GetFeatures()).response {
            (request, response, data, error) in
            
            if response == nil || response!.statusCode != 200 || error != nil {
                completionHandler(error)
                return
            }
            
            if let json = data as? NSData {
                let results = JSON(data: json)
                var temp:[Feature] = []
                for result:JSON in results.array! {
                    temp.append(Feature(json:result))
                }
                Feature.all = temp
                completionHandler(nil)
            }
        }
    }
    
    /**
    Fetch feature from Local.
    
    :param: id The ID of feature.
    :param: completionHandler The completion handler.
    
    */
    class func find(id: Int) -> Feature? {
        for feature in Feature.all {
            if feature.id == id {
                return feature
            }
        }
        println("feature not found on local.")
        return nil
    }
}