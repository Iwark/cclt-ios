//
//  TopTabBar.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/9/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

protocol TopTabBarDelegate:class {
    func tabChanged()
}

class TopTabBar: UIView {
    
    weak var topTabBarDelegate:TopTabBarDelegate?
    
    var tabBackgroundColor = UIColor("#ffffff", 0.9)
    var activeTabBackgroundColor = UIColor("#444444", 0.8)
    
    var tabFontColor = UIColor("#3c3c3c", 1.0)
    var activeTabFontColor = UIColor("#ffffff", 1.0)
    
    var triangleHeightRatio:CGFloat = 1/16
    
    var tabFontSize:CGFloat = 14.0
    
    var titles = [String]()
    
    var activeTab = 0
    
    var triangleView:TriangleView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    func layout() {
        
        let tabCount = titles.count
        if tabCount == 0 { return }
        
        let width = self.frame.size.width / CGFloat(tabCount)
        let height = self.frame.size.height
        
        for v in self.subviews {
            v.removeFromSuperview()
        }
        
        for (i,title) in enumerate(titles) {
            
            let x = width * CGFloat(i)
            
            let tabButton:TopTabBarButton = TopTabBarButton.buttonWithType(.Custom) as TopTabBarButton
            tabButton.frame = CGRectMake(x, 0, width, height)
            
            if i == activeTab {
                tabButton.titleLabel!.font = UIFont.boldSystemFontOfSize(tabFontSize)
                tabButton.backgroundColor = activeTabBackgroundColor
                tabButton.setTitleColor(activeTabFontColor, forState: .Normal)
            } else {
                tabButton.color = activeTabBackgroundColor
                tabButton.titleLabel!.font = UIFont.systemFontOfSize(tabFontSize)
                tabButton.backgroundColor = tabBackgroundColor
                tabButton.setTitleColor(tabFontColor, forState: .Normal)
            }
            
            tabButton.setTitle(title, forState: .Normal)
            tabButton.tag = i
            tabButton.addTarget(self, action: Selector("changeTab:"), forControlEvents: .TouchUpInside)
            
            self.addSubview(tabButton)
        }
        
        let tw = width * triangleHeightRatio * 2
        let th = width * triangleHeightRatio
        let tx = width * CGFloat(activeTab) + (width - tw) / 2
        let ty = height
        triangleView = TriangleView(frame: CGRectMake(tx, ty, tw, th), color:activeTabBackgroundColor)
        self.addSubview(triangleView)
        
    }
    
    func changeTab(button:UIButton) {
        
        activeTab = button.tag
        layout()
        self.topTabBarDelegate?.tabChanged()
    }

}
