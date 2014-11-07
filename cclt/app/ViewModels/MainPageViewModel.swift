//
//  MainPageViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/31/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class MainPageViewModel {
    let num:Int
    var partials:[SummaryPartialViewModel] = []
    
    init(num:Int, view:SummaryPartialView){
        self.num = num
        
        let partialViewModel = SummaryPartialViewModel(view: view)
        if let partialViews = partialViewModel.divide() {
            
            // エラーが無ければ追加
            for view in partialViews {
                var partial = SummaryPartialViewModel(view: view)
                if partial.errors.count == 0 {
                    self.partials.append(partial)
                }
            }
            
            if !validateViews(partialViews) {
                println("error!")
            }
            else {
                println("validation finished.")
            }
        } else {
            println("first divide failed")
        }
    }
    
    func validateViews(views:[SummaryPartialView]) -> Bool {
        for view in views {
            var partial = SummaryPartialViewModel(view: view)
            
            if partial.errors.count > 0 {
                // WIDTH_SHORT, HEIGHT_SHORT, AREA_SMALLの場合はfalseを返す
                if partial.hasError(.WIDTH_SHORT) || partial.hasError(.HEIGHT_SHORT) || partial.hasError(.AREA_SMALL) {
                    if partial.hasError(.AREA_SMALL){ println("AREA_SMALL") }
                    else { println("SHORT_ERROR") }
                    return false
                }
                // PORTION_UNMATCH, AREA_LARGEの場合はさらに分割を試みる
                else if partial.hasError(.PORTION_UNMATCH) || partial.hasError(.AREA_LARGE) {
                    let summaryViews = partial.divide()
                    if let summaryViews = summaryViews {
                        if !validateViews(summaryViews){
                            return false
                        }
                        else {
                            for sv in summaryViews {
                                let vm = SummaryPartialViewModel(view: sv)
                                if(vm.errors.count == 0){
                                    self.partials.append(vm)
                                }
                            }
                        }
                    }
                    else {
                        self.partials.append(partial)
                    }
                }
            }
        }
        return true
    }
}