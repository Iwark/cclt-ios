//
//  MainPage.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/21/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import Foundation

class MainPage {
    
    var partials = [SummaryPartial]()
    
    private struct Static {
        static var pages:[MainPage] = []
    }
    
    class var pages:[MainPage] {
        get { return Static.pages }
        set { Static.pages = newValue }
    }
    
    class var lastSummaryID:Int {
        if pages.count > 0 {
            let lastPage = pages[MainPage.pages.count - 1]
            if lastPage.partials.count > 0 {
                return lastPage.partials[lastPage.partials.count-1].summaryID
            }
        }
        return 0
    }
    
    init() {
        Static.pages.append(self)
    }
}