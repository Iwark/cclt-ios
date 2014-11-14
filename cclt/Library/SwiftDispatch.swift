//
//  SwiftDispatch.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/11/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation

class SwiftDispatch {
    
    class func after(delayInSeconds:Double, block:()->()){
        let time:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    class func asyncMain(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    class func asyncGlobal(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
    
}