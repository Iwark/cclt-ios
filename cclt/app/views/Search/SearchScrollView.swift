//
//  SearchScrollView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/18/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SearchScrollView: UIScrollView {

    func renderTags(tags:[Tag]){
        
        var i:CGFloat = 0
        
        for tag in tags {
            
            let label = UILabel(frame: CGRectMake(0, i * 44, 300, 44))
            label.text = tag.name
            self.addSubview(label)
            
            i++
            
        }
        
    }

}
