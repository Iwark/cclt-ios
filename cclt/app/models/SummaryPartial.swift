//
//  SummaryPartial.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/28/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

class SummaryPartial {
    let summaryID: Int
    let displayTitle: String
    let curatorName: String
    let choco: Int
    let imageURL: String
    let frame: CGRect
    let imgFrame: CGRect
    let titleFrame: CGRect
    let footerFrame: CGRect
    
    init(summary:Summary, viewModel:SummaryPartialViewModel){
        self.summaryID    = summary.id
        self.displayTitle = summary.displayTitle
        self.curatorName  = summary.curator.name
        self.choco        = summary.choco
        self.frame        = viewModel.frame
        self.imgFrame     = viewModel.imgFrame
        self.titleFrame   = viewModel.titleFrame
        self.footerFrame  = viewModel.footerFrame
        
        viewModel.setupTypes(summary.title)
        switch viewModel.imageType {
        case .Icon:
            self.imageURL = summary.icon_url
        case .Banner:
            self.imageURL = summary.banner_url
        default:
            self.imageURL = ""
        }
        
    }
    
}