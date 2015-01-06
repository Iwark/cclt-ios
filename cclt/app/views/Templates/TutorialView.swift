//
//  TutorialView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/5/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

class TutorialView: UIView {
    
    let imgView:UIImageView?
    
    init(imgView: UIImageView, frame: CGRect){
        
        self.imgView = imgView
        
        super.init()
        
        self.addSubview(imgView)
        self.frame = frame
        
        self.backgroundColor = UIColor("#000000", 0.8)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
