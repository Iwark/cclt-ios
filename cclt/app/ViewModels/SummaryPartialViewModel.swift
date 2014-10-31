//
//  SummaryPartialViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/23/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SummaryPartialViewModel{
    
    let kMinWidth:CGFloat   = 100
    let kMinHeight:CGFloat  = 100
    let kMinArea:CGFloat    = 20000
    let kMaxPortion:CGFloat = 2.0
    let kMaxArea:CGFloat    = 60000
    
    enum Error:Int {
        case WIDTH_SHORT
        case HEIGHT_SHORT
        case AREA_SMALL
        case PORTION_UNMATCH
        case AREA_LARGE
    }
    
    var errors:[Error] = []
    let view:SummaryPartialView
    
    init(view:SummaryPartialView){
        self.view = view
        self.validate()
    }
    
    /// Errorの有無をチェックしてerrorsに格納
    func validate(){
        errors = []
        
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        // 最小サイズ以上の幅を持っているかどうか
        if(width < kMinWidth){
            errors.append(.WIDTH_SHORT)
        }
        
        // 最小サイズ以上の高さを持っているかどうか
        if(height < kMinHeight){
            errors.append(.HEIGHT_SHORT)
        }
        
        // 最小サイズ以上の面積を持っているかどうか
        if(width * height < kMinArea){
            errors.append(.AREA_SMALL)
        }
        
        // 幅と高さの比率が規定以下かどうか
        if(width * kMaxPortion < height){
            errors.append(.PORTION_UNMATCH)
        }
        
        // 最大サイズ以下の面積を持っているかどうか
        if(width * height > kMaxArea){
            errors.append(.AREA_LARGE)
        }
    }
    
    /// 特定のErrorを持っているかどうか
    func hasError(error:Error) -> Bool {
        for err in errors {
            if err == error { return true }
        }
        return false
    }
    
    func divide() -> [SummaryPartialView]? {
        
        // 分割する方角
        enum Direction:Int{
            case NONE
            case HORIZONTAL
            case VERTICAL
        }
        var dir:Direction = .NONE
        
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        // 分割できない場合
        if((width < kMinWidth * 2 && height < kMinHeight * 2) || width * height < kMinArea * 2) {
            return nil
        }
        // 水平に分割
        else if width < kMinWidth * 2 && height >= kMinHeight * 2 {
            dir = .HORIZONTAL
        }
        // 垂直に分割
        else if height < kMinHeight * 2 && width >= kMinWidth * 2 {
            dir = .VERTICAL
        }
        // どちらかを分割
        else{
            dir = arc4random_uniform(2) < 1 ? .VERTICAL : .HORIZONTAL
        }
        
        let partial1 = SummaryPartialView(frame: view.frame)
        let partial2 = SummaryPartialView(frame: view.frame)
        
        while(true){
            
            if dir == .VERTICAL {
                // 幅を垂直に分割
                let minWidth = height * kMinWidth < kMinArea ? (kMinArea / height) : kMinWidth
                let pos = minWidth + CGFloat(arc4random_uniform(UInt32(width - minWidth*2 + 1)))
                partial1.frame.size.width =  pos
                partial2.frame.origin.x   += pos
                partial2.frame.size.width -= pos
            } else {
                // 高さを水平に分割
                let minHeight = width * kMinHeight < kMinArea ? (kMinArea / width) : kMinHeight
                let pos = minHeight + CGFloat(arc4random_uniform(UInt32(height - minHeight*2 + 1)))
                partial1.frame.size.height =  pos
                partial2.frame.origin.y    += pos
                partial2.frame.size.height -= pos
            }
            
            let model1 = SummaryPartialViewModel(view: partial1)
            let model2 = SummaryPartialViewModel(view: partial2)
            
            if model1.hasError(.PORTION_UNMATCH) && partial1.frame.size.width * partial1.frame.size.height < kMinArea * 2 {
                println(partial1.frame)
            } else if model2.hasError(.PORTION_UNMATCH) && partial2.frame.size.width * partial2.frame.size.height < kMinArea * 2 {
                println(partial2.frame)
            } else {
                break
            }
            
        }
        
        return [partial1, partial2]
    }
    
}