//
//  TagViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/18/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class TagViewModel {
    
}

// MARK: - Communicate with the API

extension TagViewModel {
    
    /**
    Fetch summaries from API Server.
    
    :param: completionHandler The completion handler.
    
    */
    class func fetchPopularTags(completionHandler: ([Tag]?, NSError?) -> ()) {
        
        Alamofire.request(CcltRoute.GetPopularTags()).response {
            (request, response, data, error) in
            
            if response == nil || response!.statusCode != 200 || error != nil {
                completionHandler(nil, error)
                return
            }
            
            if let json = data as? NSData {
                let results = JSON(data: json)
                var tags:[Tag] = []
                for result:JSON in results.array! {
                    tags.append(Tag(json:result))
                }
                Tag.merge(tags)
                completionHandler(tags, nil)
            }
        }
    }
}