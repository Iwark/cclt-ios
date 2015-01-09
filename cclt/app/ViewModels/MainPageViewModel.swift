//
//  MainPageViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/31/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class MainPageViewModel {
    var partials:[SummaryPartialViewModel] = []
    
    init(view:SummaryPartialView){
        
        let partialViewModel = SummaryPartialViewModel(view: view)
        if let partialViews = partialViewModel.divide() {
            
            // エラーが無ければ追加
            for view in partialViews {
                var partial = SummaryPartialViewModel(view: view)
                if partial.errors.count == 0 {
                    self.partials.append(partial)
                }
            }
            
            // TODO: errorの場合の処理
            if !validateViews(partialViews) {
                println("views validation error.")
            }
            else {
                println("validation finished.")
            }
        } else {
            println("first divide failed")
        }
    }
    
    func setSummaries(lastSummaryID:Int, callback:(NSError?)->()) {
        SummaryViewModel.fetchSummaries(lastSummaryID:lastSummaryID, num: self.partials.count,
            { [unowned self] (summaries, error) -> () in
                if let summaries = summaries {
                    for (idx, partial) in enumerate(self.partials) {
                        if(summaries.count > idx){
                            partial.summary = summaries[idx]
                            partial.setPositionType()
                            partial.view.render(partial)
                        }else{
                            println("summaries.count must not be less or equal than idx")
                        }
                    }
                    println("added new page. summaries:\(summaries)")
                    callback(nil)
                }else{
                    println("get summaries failed...:\(error)")
                    callback(error)
                }
        })
    }
    
    func validateViews(views:[SummaryPartialView]) -> Bool {
        for view in views {
            var partial = SummaryPartialViewModel(view: view)
            
            if partial.errors.count > 0 {
                // WIDTH_SHORT, HEIGHT_SHORT, AREA_SMALLの場合はfalseを返す
                if partial.hasError(.WIDTH_SHORT) || partial.hasError(.HEIGHT_SHORT) || partial.hasError(.AREA_SMALL) {
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