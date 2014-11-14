//
//  SwiftImageWithColor.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/6/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

extension UIImage {
    class func imageWithColor(color:UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
        
    }
}