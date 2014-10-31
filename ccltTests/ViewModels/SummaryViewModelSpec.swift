//
//  SummaryViewModelSpec.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/9/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Quick
import Nimble
import cclt
import SwiftyJSON

class SummaryViewModelSpec: QuickSpec {
    override func spec() {
        
        describe(".divideSummaryPartialViewToTwo") {

            it("SummaryPartialViewを2つに分割すること"){

            }

        }

        describe(".divideSummaryPartialViewToMany"){

            it("SummaryPartialViewをN個に分割すること"){

            }

        }

        describe(".validateSummaryPartialView"){

            describe("#width"){
                context("100px以上のとき"){

                }
            }

            describe("#height"){
                context("100px以上のとき"){

                }
                context("幅の２倍以下のとき"){

                }
            }

            describe("#area"){
                context("800px以下のとき"){

                }
            }

        }

        describe(".fetchAll") {
            
            it("まとめ一覧を取得できること"){
                
                var summaries:[Summary] = []
                
                SummaryViewModel.fetchAll { (error) in
                    expect(error).to(beNil())
                    summaries = Summary.all
                }
                
                expect(summaries.count).toEventuallyNot(equal(0), timeout: 3)
            }
        
        }
        
        describe(".fetchOne") {
            
            it("まとめを１件、取得できること"){
                
                var summary = Summary(json: JSON([:]))
                
                SummaryViewModel.find(101) { (result, error) in
                    expect(error).to(beNil())
                    summary = result!
                }
                
                expect(summary.title).toEventuallyNot(equal(""), timeout: 3)
            }
            
        }
    }
}