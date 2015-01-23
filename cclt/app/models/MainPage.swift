//
//  MainPage.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/21/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import Foundation

class MainPage {
    
    private struct Static {
        static var pages:[MainPageViewModel] = []
    }
    
    class var pages:[MainPageViewModel] {
        get { return Static.pages }
        set { Static.pages = newValue }
    }
    
    class var lastSummaryID:Int {
        if pages.count > 0 {
            let lastPage = pages[MainPage.pages.count - 1]
            if lastPage.partials.count > 0 {
                if let summaryID = lastPage.partials[lastPage.partials.count-1].summary?.id {
                    return summaryID
                }
            }
        }
        return 0
    }
}