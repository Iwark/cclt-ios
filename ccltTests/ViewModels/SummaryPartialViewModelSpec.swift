//
//  SummaryPartialViewModelSpec.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/29/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Quick
import Nimble
import cclt
import SwiftyJSON
import UIKit

class SummaryPartialViewModelSpec: QuickSpec {
    override func spec() {
        describe("#divide") {

            context("width >= minWidth * 2 かつ height >= minHeight * 2のとき"){
                let view = SummaryPartialView(frame:CGRectMake(0, 0, 320, 480))
                let viewModel = SummaryPartialViewModel(view: view)
                
                let views = viewModel.divide()
                
                it("結果が返ってくること"){
                    expect(views).toNot(beNil())
                }
                
                it("２つに分割されること"){
                    expect(views!.count).to(equal(2))
                }
                
                it("それぞれ幅と高さが一定以上であること"){
                    for v in views! {
//                        expect(v.frame.size.width) > kMinWidth
//                        expect(v.frame.size.height) > kMinHeight
                    }
                }
            }
            
            context("width < minWidth * 2 かつ height < minHeight * 2のとき"){
                let view = SummaryPartialView(frame:CGRectMake(0, 0, 100, 100))
                let viewModel = SummaryPartialViewModel(view: view)
                let views = viewModel.divide()
                
                it("結果がnilであること"){
                    expect(views).to(beNil())
                }
            }

        }

        describe("#validate"){

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
    }
}