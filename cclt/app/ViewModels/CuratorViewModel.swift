//
//  CuratorViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/27/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class CuratorViewModel {
    
}

// MARK: - Communicate with the API

extension CuratorViewModel {
    
    /**
    Fetch curators from API Server.
    
    :param: completionHandler The completion handler.
    
    */
    class func fetchAll(completionHandler: (NSError?) -> ()) {
        Alamofire.request(CcltRoute.GetCurators()).response {
            (request, response, data, error) in
            
            if response == nil || response!.statusCode != 200 || error != nil {
                completionHandler(error)
                return
            }
            
            if let json = data as? NSData {
                let results = JSON(data: json)
                var temp:[Curator] = []
                for result:JSON in results.array! {
                    temp.append(Curator(json:result))
                }
                Curator.all = temp
                completionHandler(nil)
            }
        }
    }
    
    /**
    Fetch curator from Local || API Server.
    
    :param: id The ID of curator.
    :param: completionHandler The completion handler.
    
    */
    class func find(id: Int, completionHandler: (Curator?, NSError?) -> Void) {
        for curator in Curator.all {
            if curator.id == id {
                completionHandler(curator, nil)
                return
            }
        }
        println("curator not found on local... trying to fetch.")
        self.fetchOne(id, completionHandler)
    }
    
    /**
    Fetch curator from API Server.
    
    :param: id The ID of curator.
    :param: completionHandler The completion handler.
    
    */
    private class func fetchOne(id: Int, completionHandler: (Curator?, NSError?) -> Void) {
        Alamofire.request(CcltRoute.GetCurator(id)).response {
            (request, response, data, error) in
            
            if response == nil || response!.statusCode != 200 || error != nil {
                completionHandler(nil, error)
                return
            }
            
            if let json = data as? NSData {
                let result = JSON(data: json)
                let curator = Curator(json: result)
                completionHandler(curator, nil)
            }
        }
    }
}