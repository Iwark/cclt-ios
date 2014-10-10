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

    case Summaries()

    var path: (Alamofire.Method, String) {
        switch self {
            case .Summaries:
                return (.GET, "summaries")
        }
    }
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: CcltRoute.baseURLString)
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path.1))
        mutableURLRequest.HTTPMethod = path.0.toRaw()
            
//            if let token = Router.OAuthToken {
//                mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            }
            
        switch self {
//            case .CreateUser(let parameters):
//                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
//            case .UpdateUser(_, let parameters):
//                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
        }
    }
}