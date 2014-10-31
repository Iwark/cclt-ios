//
//  FeatureSpec.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/15/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Quick
import Nimble
import cclt
import SwiftyJSON

class FeatureViewModelSpec: QuickSpec {
    override func spec() {
        
        beforeEach {
            Feature.all = []
        }
        
        describe(".fetchAll") {
            
            it("特集一覧を取得できること"){
                
                var features:[Feature] = []
                
                FeatureViewModel.fetchAll { (error) in
                    expect(error).to(beNil())
                    features = Feature.all
                }
                
                expect(features.count).toEventuallyNot(equal(0), timeout: 3)
            }
            
        }
        
        describe(".find") {
            
            context("when .fetchAll was already done"){
                
                it("特集を１件、取得できること"){
                    
                    var feature:Feature? = nil
                    
                    FeatureViewModel.fetchAll { (error) in
                        expect(error).to(beNil())
                        feature = FeatureViewModel.find(1)
                    }
                    
                    expect(feature).toEventuallyNot(beNil(), timeout: 3)
                }
            }
            
            context("when .fetchAll was NOT done"){
                
                it("特集を１件、取得できないこと"){
                    let feature = FeatureViewModel.find(1)
                    
                    expect(feature).to(beNil())
                }
                
            }
            
        }
    }
}