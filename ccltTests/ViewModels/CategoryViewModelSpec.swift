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

class CategoryViewModelSpec: QuickSpec {
    override func spec() {
        
        beforeEach {
            Category.all = []
        }
        
        describe(".fetchAll") {
            
            it("カテゴリ一覧を取得できること"){
                
                var categories:[Category] = []
                
                CategoryViewModel.fetchAll { (error) -> Void in
                    expect(error).to(beNil())
                    categories = Category.all
                }
                
                expect(categories.count).toEventuallyNot(equal(0), timeout: 3)
            }
            
        }
        
        describe(".find") {
            
            context("when .fetchAll was already done"){
                
                it("カテゴリを１件、取得できること"){
                    
                    var category:Category? = nil
                    
                    CategoryViewModel.fetchAll { (error) in
                        expect(error).to(beNil())
                        category = CategoryViewModel.find(1)
                    }
                    
                    expect(category).toEventuallyNot(beNil(), timeout: 3)
                }
            }
            
            context("when .fetchAll was NOT done"){
                
                it("カテゴリを１件、取得できないこと"){
                    let category = CategoryViewModel.find(1)
                    
                    expect(category).to(beNil())
                }
                
            }
            
        }
    }
}