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
    var views:[SummaryPartialView] = []
    
    init(num:Int, view:SummaryPartialView){
        self.num = num
        
        let partialViewModel = SummaryPartialViewModel(view: view)
        if let partialViews = partialViewModel.divide() {
            
            if !validateViews(partialViews) {
                println("error!")
            }
            else {
                println("validation finished.")
            }
        }
    }
    
    var a = 1
    
    func validateViews(views:[SummaryPartialView]) -> Bool {
        println("validateViews: \(a)")
        a++
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
                    
                    println("frame:\(partial.view.frame)")
                    if partial.hasError(.PORTION_UNMATCH){ println("PORTION") }
                    if partial.hasError(.AREA_LARGE){ println("AREA_LARGE") }
                    
                    let summaryViews = partial.divide()
                    if let summaryViews = summaryViews {
                        if !validateViews(summaryViews){
                            return false
                        }
                        else {
                            println("validation ok")
                            
                            for sv in summaryViews {
                                let vm = SummaryPartialViewModel(view: sv)
                                if(vm.errors.count == 0){
                                    self.views.append(sv)
                                    println("added: \(sv.frame)")
                                }
                            }
                        }
                    }
                    else {
                        println("divide failed")
                        return false
                    }
                }
            }
        }
        return true
    }
}