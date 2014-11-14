//
//  CcltRoute.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/9/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum CcltRoute: URLRequestConvertible {
    static let baseURLString = "http://cclt.jp/api/v1/"
    static var OAuthToken: String?
    
    // カテゴリ
    case GetCategories()
    
    // キュレーター
    case GetCurator(Int)
    case GetCurators()
    
    // 特集
    case GetFeature(Int)
    case GetFeatures()
    
    // まとめ
    case GetSummary(Int)
    case GetSummaries(Int, Int)
    case GetPickupSummaries()
    
    var path: (Alamofire.Method, String) {
        switch self {
        case .GetCategories:
            return (.GET, "categories")
            
            
        case .GetCurator(let id):
            return (.GET, "curators/\(id)")
            
        case GetCurators:
            return (.GET, "curators")
            
            
        case .GetFeature:
            return (.GET, "feature")
            
        case .GetFeatures:
            return (.GET, "features")
            
            
        case .GetSummary(let id):
            return(.GET, "summaries/\(id)")
        case .GetSummaries(let lastSummaryID, let num):
            return(.GET, "summaries")
        case .GetPickupSummaries():
            return(.GET, "pickup_summaries")
            }

}

    var URLRequest: NSURLRequest {
        let URL = NSURL(string: CcltRoute.baseURLString)
        let mutableURLRequest = NSMutableURLRequest(URL: URL!.URLByAppendingPathComponent(path.1))
        mutableURLRequest.HTTPMethod = path.0.rawValue
            
//            if let token = Router.OAuthToken {
//                mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            }
            
        switch self {
        case .GetSummaries(let lastSummaryID, let num):
            let params = ["last_summary_id": lastSummaryID, "num":num]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
//            case .CreateUser(let parameters):
//                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
//            case .UpdateUser(_, let parameters):
//                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}