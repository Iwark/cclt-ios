//
//  MainPageViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/31/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class MainPageViewModel {
}

// MARK: - Communicate with the API

extension MainPageViewModel {

    class func addMainPage(lastSummaryID:Int, partials:[SummaryPartialViewModel], callback:()->()){
        
        SummaryViewModel.fetchSummaries(lastSummaryID:lastSummaryID, num: partials.count) {
            (summaries, error) in
            
            if let summaries = summaries {
                
                let mainPage = MainPage()
                var summaryPartials = [SummaryPartial]()
                for (idx,summary) in enumerate(summaries) {
                    summaryPartials.append(SummaryPartial(summary: summary, viewModel: partials[idx]))
                }
                mainPage.partials = summaryPartials
                callback()
            }else{
                println("get summaries failed...:\(error)")
                
                // 再取得
                SwiftDispatch.after(0.5, block: {
                    self.addMainPage(lastSummaryID, partials: partials, callback: callback)
                })
            }
        }
        
    }
    
}
