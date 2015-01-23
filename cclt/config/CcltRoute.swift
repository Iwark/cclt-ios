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
    case GetSummaries(Int, Int, Int, Int)
    case SendImpression(Int, String)
    case SendShare(Int, String, String)
    case GetPopularTags()
    case SearchSummaries(String, Int)
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
        case .GetSummaries(let categoryID, let featureID, let lastSummaryID, let num):
            return(.GET, "summaries")
        case .SendImpression(let id, let uuid):
            return(.GET, "summaries/\(id)/imp")
        case .SendShare(let id, let provider, let uuid):
            return(.GET, "summaries/\(id)/share")
        case .GetPopularTags():
            return(.GET, "summaries/popular_tags")
        case .SearchSummaries(let q, let page):
            return(.GET, "summaries/search")
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
        case .GetSummaries(let categoryID, let featureID, let lastSummaryID, let num):
            let params = ["category_id": categoryID, "feature_id": featureID, "last_summary_id": lastSummaryID, "num":num]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .SearchSummaries(let q, let page):
            let params = ["q": q, "page": page] as [String: AnyObject]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .SendImpression(let id, let uuid):
            let params = ["uuid": uuid]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .SendShare(let id, let provider, let uuid):
            let params = ["uuid": uuid, "provider": provider]
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