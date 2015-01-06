//
//  SummaryPartialViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/23/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SummaryPartialViewModel{
    
    var kMinWidth:CGFloat   = 120
    var kMinHeight:CGFloat  = 100
    var kMinArea:CGFloat    = 20000
    let kMaxPortion:CGFloat = 1.7
    var kMaxArea:CGFloat    = 56000
    let kMaxDivPortion:CGFloat = 1.5
    
    let kHorizontalBannerPortion:CGFloat = 0.45   // 横（バナー+テキスト）
    let kHorizontalIconPortion:CGFloat   = 0.55   // 横（アイコン+テキスト）
    let kTextOnlyPortion:CGFloat         = 1.0    // テキストのみ
    let kVerticalBannerPortion:CGFloat   = 1.4    // 縦（バナー+テキスト）
    let kSmallImageArea:CGFloat          = 30000  // 小画像
    let kSmallHorizontalPortion:CGFloat  = 0.75   // 横（小アイコン+テキスト）
    
    enum Error:Int {
        case WIDTH_SHORT
        case HEIGHT_SHORT
        case AREA_SMALL
        case PORTION_UNMATCH
        case AREA_LARGE
    }
    
    enum PositionType:Int {
        case SMALL_IMAGE_TOP_TEXT_BOTTOM
        case IMAGE_TOP_TEXT_BOTTOM
        case ICON_TOP_TEXT_BOTTOM
        case IMAGE_LEFT_TEXT_RIGHT
        case IMAGE_RIGHT_TEXT_LEFT
        case ICON_LEFT_TEXT_RIGHT
        case ICON_RIGHT_TEXT_LEFT
        case SMALL_ICON_LEFT_TEXT_RIGHT
        case SMALL_ICON_RIGHT_TEXT_LEFT
        case TEXT_ONLY
    }
    
    var errors:[Error] = []
    let view:SummaryPartialView
    var summary:Summary?
    var positionType:PositionType = .TEXT_ONLY
    
    init(view:SummaryPartialView){
        
        var r = UIScreen.mainScreen().applicationFrame.size.width / 320
        if r > 2 { r *= 0.8 }  // iPad用に最適化
        kMinWidth  *= r
        kMinHeight *= r
        kMinArea   *= r
        kMaxArea   *= r
        
        self.view = view
        self.validate()
    }

    /// Errorの有無をチェックしてerrorsに格納
    func validate(){
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
    
    func setPositionType() {
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        var type:PositionType = .TEXT_ONLY
        
        // 横（バナー+タイトル）
        if height < width * kHorizontalBannerPortion {
            type = arc4random_uniform(2) < 1 ? .IMAGE_LEFT_TEXT_RIGHT : .IMAGE_RIGHT_TEXT_LEFT
        }
        // 横（アイコン+タイトル）
        else if height < width * kHorizontalIconPortion {
            type = arc4random_uniform(2) < 1 ? .ICON_LEFT_TEXT_RIGHT : .ICON_RIGHT_TEXT_LEFT
        }
        else if height < width * kTextOnlyPortion {
            if width * height > kSmallImageArea{
                if height < width * kSmallHorizontalPortion {
                    // 横（小アイコン+タイトル)
                    type = arc4random_uniform(2) < 1 ? .SMALL_ICON_LEFT_TEXT_RIGHT : .SMALL_ICON_RIGHT_TEXT_LEFT
                } else {
                    // 縦（小バナー+タイトル）
                    type = .SMALL_IMAGE_TOP_TEXT_BOTTOM
                }
            }else{
                // テキストのみ
                type = .TEXT_ONLY
            }
        }
        // 縦（バナー+タイトル）
        else if height < width * kVerticalBannerPortion {
            type = .IMAGE_TOP_TEXT_BOTTOM
        }
        // 縦（アイコン+タイトル）
        else {
            type = .ICON_TOP_TEXT_BOTTOM
        }
        
        self.positionType = type
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
        let area = width * height
        
        // 分割できない場合
        if((width < kMinWidth * 2 && height < kMinHeight * 2) || width * height < kMinArea * 2) {
            return nil
        }
        // 水平に分割
        else if area < kMaxArea * 2.0 && width * kMaxDivPortion < height {
            dir = .HORIZONTAL
        }
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
        
        if dir == .VERTICAL {
            // 幅を垂直に分割
            let minWidth = height * kMinWidth < kMinArea ? (kMinArea / height) : kMinWidth
            let pos = minWidth + CGFloat(arc4random_uniform(UInt32(width - minWidth*2 + 1)))
            partial1.frame.size.width  = pos
            partial2.frame.origin.x   += pos
            partial2.frame.size.width -= pos
        } else {
            // 高さを水平に分割
            let minHeight = width * kMinHeight < kMinArea ? (kMinArea / width) : kMinHeight
            let pos = minHeight + CGFloat(arc4random_uniform(UInt32(height - minHeight*2 + 1)))
            partial1.frame.size.height  = pos
            partial2.frame.origin.y    += pos
            partial2.frame.size.height -= pos
        }
        
        return [partial1, partial2]
    }
    
}