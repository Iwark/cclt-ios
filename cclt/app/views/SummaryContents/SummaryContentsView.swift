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
    
    let sourceLabelHeight:CGFloat = 18.0
    let sourceLabelTopMargin:CGFloat = 3.0

    weak var summaryContentsViewDelegate:SummaryContentsViewDelegate?
    
}
