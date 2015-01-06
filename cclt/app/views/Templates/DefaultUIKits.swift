//
//  DefaultUIKits.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/6/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

class DefaultTextLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textColor = Settings.Colors.textColor
        self.font = Settings.Fonts.mediumFont
        self.numberOfLines = 0
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
