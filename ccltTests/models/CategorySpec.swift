//
//  CategorySpec.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/14/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Quick
import Nimble
import cclt

class CategorySpec: QuickSpec {
    override func spec() {
        
        describe(".fetchAll") {
            
            it("カテゴリ一覧を取得できること"){
                
                var categories:[Category] = []
                
                Category.fetchAll { (status, results) -> Void in
                    expect(status).to(equal(200))
                    categories = results
                }
                
                expect(categories.count).toEventuallyNot(equal(0), timeout: 3)
            }
            
        }
    }
}