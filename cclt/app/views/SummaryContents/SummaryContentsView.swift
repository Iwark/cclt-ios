//
//  SummaryContentsView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/15/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

protocol SummaryContentsViewDelegate:class {
    func layout()
    func linkTapped(url: NSURL)
}

class SummaryContentsView: UIView {
    
    let sourceLabelHeight:CGFloat = 20.0
    let sourceLabelTopMargin:CGFloat = 2.0

    weak var summaryContentsViewDelegate:SummaryContentsViewDelegate?
    
}
