//
//  WebMenuBarButtonItem.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/20/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

protocol WebMenuBarButtonItemDelegate:class {
    func menuOpened()
}

class WebMenuBarButtonItem: UIBarButtonItem {
    weak var delegate:WebMenuBarButtonItemDelegate?
    
    init(delegate: WebMenuBarButtonItemDelegate) {
        
        self.delegate = delegate
        
        super.init()
        
        let imgOff = UIImage(named: "btn_browser_off")
        let imgOn  = UIImage(named: "btn_browser_on")
        let button   = UIButton(frame: CGRectMake(0, 0, imgOff!.size.width, imgOff!.size.height))
        
        button.setBackgroundImage(imgOff, forState:.Normal)
        button.setBackgroundImage(imgOn, forState: .Highlighted)
        button.addTarget(self, action: Selector("open"), forControlEvents: .TouchUpInside)
        
        self.customView = button
        
    }
    
    func open(){
        self.delegate?.menuOpened()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}