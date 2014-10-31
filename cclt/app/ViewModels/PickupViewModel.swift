//
//  PickupViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/23/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class PickupViewModel {
    
}

// MARK: - Communicate with the API

extension PickupViewModel {
    
    // MARK: Pickups
    
    /**
    Fetch pickups from API Server.
    
    :param: completionHandler The completion handler.
    
    */
    class func fetchSummaries(completionHandler: (NSError?) -> ()) {
        Alamofire.request(CcltRoute.GetPickupSummaries()).response {
            (request, response, data, error) in
            
            if response == nil || response!.statusCode != 200 || error != nil {
                completionHandler(error)
                return
            }
            
            if let json = data as? NSData {
                let results = JSON(data: json)
                var temp:[Summary] = []
                for result:JSON in results.array! {
                    temp.append(Summary(json:result))
                }
                Pickup.summaries = temp
                completionHandler(nil)
            }
        }
    }
    
}