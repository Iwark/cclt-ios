//
//  CuratorViewModelSpec.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/27/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Quick
import Nimble
import cclt
import SwiftyJSON

class CuratorViewModelSpec: QuickSpec {
    override func spec() {
        
        describe(".fetchAll") {
            
            it("キュレータ一覧を取得できること"){
                
                var curators:[Curator] = []
                
                CuratorViewModel.fetchAll { (error) in
                    expect(error).to(beNil())
                    curators = Curator.all
                }
                
                expect(curators.count).toEventuallyNot(equal(0), timeout: 3)
            }
            
        }
        
        describe(".fetchOne") {
            
            it("キュレータを１件、取得できること"){
                
                var curator:Curator? = nil
                
                CuratorViewModel.find(101) { (result, error) in
                    expect(error).to(beNil())
                    curator = result!
                }
                
                expect(curator).toEventuallyNot(beNil(), timeout: 3)
            }
            
        }
    }
}
