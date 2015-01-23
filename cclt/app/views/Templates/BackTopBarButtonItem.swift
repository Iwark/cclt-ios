//
//  BackTopBarButtonItem.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/21/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

protocol BackTopBarButtonItemDelegate:class {
    func backToTop()
}

class BackTopBarButtonItem: UIBarButtonItem {
    weak var delegate:BackTopBarButtonItemDelegate?
    
    init(delegate: BackTopBarButtonItemDelegate) {
        
        self.delegate = delegate
        
        super.init()
        
        let backImageOff = UIImage(named: "btn_backtop_off")
        let backImageOn  = UIImage(named: "btn_backtop_on")
        let backButton   = UIButton(frame: CGRectMake(0, 0, backImageOff!.size.width, backImageOff!.size.height))
        
        backButton.setBackgroundImage(backImageOff, forState:.Normal)
        backButton.setBackgroundImage(backImageOn, forState: .Highlighted)
        backButton.addTarget(self, action: Selector("backToTop"), forControlEvents: .TouchUpInside)
        
        self.customView = backButton
        
    }
    
    func backToTop(){
        self.delegate?.backToTop()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}