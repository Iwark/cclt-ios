//
//  BackBarButtonItem.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

protocol BackBarButtonItemDelegate:class {
    func pop()
}

class BackBarButtonItem: UIBarButtonItem {
    weak var delegate:BackBarButtonItemDelegate?
    
    init(delegate: BackBarButtonItemDelegate) {
        
        self.delegate = delegate

        super.init()
        
        let backImageOff = UIImage(named: "btn_back_off")
        let backImageOn  = UIImage(named: "btn_back_on")
        let backButton   = UIButton(frame: CGRectMake(0, 0, backImageOff!.size.width, backImageOff!.size.height))
        
        backButton.setBackgroundImage(backImageOff, forState:.Normal)
        backButton.setBackgroundImage(backImageOn, forState: .Highlighted)
        backButton.addTarget(self, action: Selector("pop"), forControlEvents: .TouchUpInside)
        
        self.customView = backButton
        
    }
    
    func pop(){
        self.delegate?.pop()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
