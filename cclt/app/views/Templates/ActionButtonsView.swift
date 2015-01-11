//
//  ActionButtonsView.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/10/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

class ActionButtonsView: UIView {

    let url:String
    
    init(frame: CGRect, url:String) {
        self.url = url
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        let like = FBLikeControl()
        like.objectID = url
//        like.objectType = .Page
        like.likeControlStyle = .BoxCount
        like.likeControlAuxiliaryPosition = .Top
        like.likeControlHorizontalAlignment = .Center
        self.addSubview(like)
        
        let loginView = FBLoginView(publishPermissions: ["publish_actions"], defaultAudience: .Everyone)
        loginView.frame.origin.x = 200
        self.addSubview(loginView)
        
        let org = UIButton(frame: CGRectMake(60, 0, 80, 40))
        org.setTitle("いいね！", forState: .Normal)
        org.addTarget(self, action: Selector("like"), forControlEvents: .TouchUpInside)
        self.addSubview(org)
        
    }
    
    func like(){
        let params = ["object":url]

        FBRequestConnection.startWithGraphPath("/me/og.likes", parameters: params, HTTPMethod: "POST") { (connection, result, error) in
            println(connection)
            println(result)
            println(error)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
