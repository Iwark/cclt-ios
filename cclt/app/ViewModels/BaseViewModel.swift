//
//  BaseViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/24/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

//import Foundation
//import SwiftyJSON
//import Alamofire
//
//class BaseViewModel {
//    
//}
//
//// MARK: - Communicate with the API
//
//extension BaseViewModel {
//    
//    /**
//    Fetch All from API Server.
//    
//    :param: completionHandler The completion handler.
//    
//    */
//    class func fetchAll<T:BaseModel>(target:T, route:CcltRoute, completionHandler: (NSError?) -> ()) {
//        Alamofire.request(route).response {
//            (request, response, data, error) in
//            
//            if response == nil || response!.statusCode != 200 || error != nil {
//                completionHandler(error)
//                return
//            }
//            
//            if let json = data as? NSData {
//                let results = JSON(data: json)
//                var temp:[T] = []
//                for result:JSON in results.array! {
//                    temp.append(T(json:result))
//                }
//                T.all = temp
//                completionHandler(nil)
//            }
//        }
//    }
//    
//    /**
//    Fetch summary from Local || API Server.
//    
//    :param: id The ID of summary.
//    :param: completionHandler The completion handler.
//    
//    */
////    class func find(id: Int, completionHandler: (Summary?, NSError?) -> Void) {
////        for summary in Summary.summaries{
////            if summary.id == id {
////                completionHandler(summary, nil)
////                return
////            }
////        }
////        println("summary not found on local... trying to fetch.")
////        self.fetchOne(id, completionHandler)
////    }
//    
//    /**
//    Fetch summary from API Server.
//    
//    :param: id The ID of summary.
//    :param: completionHandler The completion handler.
//    
//    */
////    private class func fetchOne(id: Int, completionHandler: (Summary?, NSError?) -> Void) {
////        Alamofire.request(CcltRoute.GetSummary(id)).response {
////            (request, response, data, error) in
////            
////            if response == nil || response!.statusCode != 200 || error != nil {
////                completionHandler(nil, error)
////                return
////            }
////            
////            if let json = data as? NSData {
////                let result = JSON(data: json)
////                let summary:Summary = Summary(json: result)
////                completionHandler(summary, nil)
////            }
////        }
////    }
//}