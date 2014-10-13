//
//  ccltTests.swift
//  ccltTests
//
//  Created by Kohei Iwasaki on 10/9/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Quick
import Nimble
import cclt
import Alamofire
import SwiftyJSON

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        
        describe("the table of contents below") {
            
            it("Alamofire"){
                
                var summaries:JSON = JSON([["title":"test quick title"]])
                
                Alamofire.request(CcltRoute.Summaries()).response {
                    (request, response, data, error) in
                    
                    if let json = data as? NSData {
                        summaries = JSON(data: json)
                    }
                }
                
                expect(summaries.array![0]["title"]).toEventuallyNot(equal("test quick title"), timeout: 3)
            }
        
        }
    }
}