//
//  TutorialView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/21/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

protocol TutorialViewDelegate:class {
    func hideTutorial()
}

class TutorialView: UIView {
    
    weak var delegate:TutorialViewDelegate?
    
    let leftArrow:UIImageView!
    let rightArrow:UIImageView!
    
    let arrowMargin:CGFloat = 2.0
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        self.backgroundColor = Settings.Colors.tutorialLightGrayColor
        
        // tap to hide
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideTutorial"))
        self.addGestureRecognizer(tapGesture)
        
        let arrowImg = UIImage(named: "arrow_a")!
        rightArrow = UIImageView(frame: CGRectMake(
            self.frame.size.width - arrowImg.size.width - arrowMargin,
            self.center.y - arrowImg.size.height / 2,
            arrowImg.size.width,
            arrowImg.size.height
        ))
        rightArrow.image = arrowImg
        
        leftArrow = UIImageView(frame: rightArrow.frame)
        leftArrow.image = arrowImg
        
        leftArrow.frame.origin.x = arrowMargin
        leftArrow.transform = CGAffineTransformScale(rightArrow.transform, -1, 1)
        
        showArrows()
        
    }
    
    func hideTutorial(){
        self.delegate?.hideTutorial()
    }
    
    func showArrows(){
        self.addSubview(leftArrow)
        self.addSubview(rightArrow)
    }
    
    func hideArrows(){
        leftArrow.removeFromSuperview()
        rightArrow.removeFromSuperview()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
