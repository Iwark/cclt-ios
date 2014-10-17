//
//  SummarySpec.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/9/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Quick
import Nimble
import cclt
import SwiftyJSON

class SummarySpec: QuickSpec {
    override func spec() {
        
        describe(".fetchAll") {
            
            it("まとめ一覧を取得できること"){
                
                var summaries:[Summary] = []
                
                Summary.fetchAll { (status, results) -> Void in
                    expect(status).to(equal(200))
                    summaries = results
                }
                
                expect(summaries.count).toEventuallyNot(equal(0), timeout: 3)
            }
        
        }
        
        describe(".fetchOne") {
            
            it("まとめを１件、取得できること"){
                
                var summary = Summary(json: JSON([:]))
                
                Summary.find(101) { (status, result) -> Void in
                    expect(status).to(equal(200))
                    summary = result
                }
                
                expect(summary.title).toEventuallyNot(equal(""), timeout: 3)
            }
            
        }
    }
}