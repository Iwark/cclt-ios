//
//  PickupViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/27/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Quick
import Nimble
import cclt
import SwiftyJSON

class PickupViewModelSpec: QuickSpec {
    override func spec() {
        
        describe(".fetchPickups") {
            
            it("ピックアップ記事一覧を取得できること"){
                
                var summaries:[Summary] = []
                
                PickupViewModel.fetchSummaries { (error) in
                    expect(error).to(beNil())
                    summaries = Pickup.summaries
                }
                
                expect(summaries.count).toEventuallyNot(equal(0), timeout: 3)
            }
            
        }
    }
}