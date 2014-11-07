//
//  SwiftColorWithHex.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/6/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(_ hex:String, _ alpha:CGFloat) {
        var hexString = hex
        if hex.hasPrefix("#") {
            hexString = hex.substringFromIndex(advance(hex.startIndex, 1))
        }
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        
        let scanner = NSScanner(string: hexString)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexLongLong(&hexValue) {
            if countElements(hexString) == 3 {
                red   = CGFloat((hexValue & 0xF00) >> 8) / 255.0
                green = CGFloat((hexValue & 0x0F0) >> 4)  / 255.0
                blue  = CGFloat(hexValue & 0x00F) / 255.0
            } else if countElements(hexString) == 6 {
                red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                blue  = CGFloat(hexValue & 0x0000FF) / 255.0
            } else {
                print("invalid rgb string, length should be 7 or 9")
            }
        } else {
            println("scan hex error")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}