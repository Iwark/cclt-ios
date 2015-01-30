//
//  SummaryPartialViewModel.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/23/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

// 定数
struct Const {
    
    static let bannerPortion:CGFloat      = 0.6   // バナーの縦横比
    static let contentsPadding:CGFloat    = 6.0   // コンテンツ間の間隔
    static let footerHeight:CGFloat       = 16.0  // フッターの大きさ
    static let footerMarginBottom:CGFloat = 4.0   // フッター下部のマージン
    
    // 存在可能条件
    static let r = (Settings.appWidth / 320) > 2 ? Settings.appWidth / 400 : Settings.appWidth / 320
    static let minWidth:CGFloat   = 120 //* r
    static let minHeight:CGFloat  = 100 //* r
    static let minArea:CGFloat    = 20000 //* r
    static let maxPortion:CGFloat = 1.5
    
    // 分割必須条件
    static let maxArea:CGFloat    = 56000 //* r
    
    // 画像を表示するための最小ラベル面積
    static let minLabelAreaToShowImage:CGFloat   = 10000
    // 画像を表示するための最小ラベル幅
    static let minLabelWidthToShowImage:CGFloat  = 92
    // 画像を表示するための最小ラベル高さ
    static let minLabelHeightToShowImage:CGFloat = 50
}

class SummaryPartialViewModel{
    
    /// 分割方向
    enum DivideDirection {
        case Horizontally
        case Vertically
    }
    
    /// 配置方向
    enum ArrangeType {
        case Horizontally
        case Vertically
        case None
    }

    /// 画像タイプ
    enum ImageType {
        case Banner
        case Icon
        case None
    }
    
    // メンバー変数
    let frame:CGRect
    var imgFrame    = CGRectZero
    var titleFrame  = CGRectZero
    var footerFrame = CGRectZero
    
    var arrangeType:ArrangeType = .None
    var imageType:ImageType = .None
    
    init(frame:CGRect) {
        self.frame = frame
    }
    
    /// 分割可能最小距離X
    func minDistanceX(frame:CGRect) -> CGFloat {
        var distance = Const.minWidth
        if frame.size.height * Const.minWidth < Const.minArea {
            distance = Const.minArea / frame.size.height
        }
        return distance
    }
    
    /// 分割可能最小距離Y
    func minDistanceY(frame:CGRect) -> CGFloat {
        var distance = Const.minHeight
        if frame.size.width * Const.minHeight < Const.minArea {
            distance = Const.minArea / frame.size.width
        }
        return distance
    }
    
    /**
    再帰的に最小単位まで分割
    */
    func divideToUnit() -> [SummaryPartialViewModel]? {
        if let divided = self.divide() {
            var results = [SummaryPartialViewModel]()
            for vm in divided {
                println("dividing")
                if let dvms = vm.divideToUnit() {
                    results.extend(dvms)
                } else {
                    results.append(vm)
                }
            }
            println("results count = \(results.count)")
            return results
        } else {
            println("returning self")
            return nil
        }
    }
    
    /**
    分割
    これ以上分割できない場合はnilを返す。
    */
    func divide() -> [SummaryPartialViewModel]? {
        
        // 分割する方角の決定
        let directions = self.dividableDirections(self.frame, count: 2)
        println("directions count: \(directions.count)")
        
        if directions.count == 0 {
            return nil
        }
        
        var dir:DivideDirection
        if directions.count == 1 {
            dir = directions[0]
        } else {
            dir = arc4random_uniform(2) < 1 ? .Vertically : .Horizontally
        }
        
        var rects:(CGRect,CGRect)
        if dir == .Vertically {
            // 幅を垂直に分割
            let x = minDistanceX(self.frame)
            let randomLength = arc4random_uniform(UInt32(self.frame.size.width - x * 2))
            let pos = x + CGFloat(randomLength)
            rects = self.frame.rectsByDividing(pos, fromEdge: .MinXEdge)
        } else {
            // 高さを水平に分割
            let y = minDistanceY(self.frame)
            let randomLength = arc4random_uniform(UInt32(self.frame.size.height - y * 2))
            let pos = y + CGFloat(randomLength)
            rects = self.frame.rectsByDividing(pos, fromEdge: .MinYEdge)
        }
        
        return [SummaryPartialViewModel(frame: rects.0), SummaryPartialViewModel(frame: rects.1)]
    }
    
    /**
    分割可能な方角
    */
    func dividableDirections(frame: CGRect, count: Int) -> [DivideDirection] {
        
        var results = [DivideDirection]()
        
        // 垂直方向に分割可能かどうか
        if frame.size.width >= Const.minWidth * 2 {
            println("minDistanceX: \(minDistanceX(frame)) frame: \(frame)")
            let vertically = frame.rectsByDividing(minDistanceX(frame), fromEdge: .MinXEdge)
            println("vertically1: \(vertically.0)")
            println("vertically2: \(vertically.1)")
            if self.validate(vertically.0, count: count - 1) && self.validate(vertically.1, count: count - 1) {
                results.append(.Vertically)
            }
        }
        
        // 水平方向に分割可能かどうか
        if frame.size.height >= Const.minHeight * 2 {
            println("minDistanceY: \(minDistanceY(frame)) frame: \(frame)")
            let horizontally = frame.rectsByDividing(minDistanceY(frame), fromEdge: .MinYEdge)
            println("horizontally1: \(horizontally.0)")
            println("horizontally2: \(horizontally.1)")
            if self.validate(horizontally.0, count: count - 1) && self.validate(horizontally.1, count: count - 1) {
                results.append(.Horizontally)
            }
        }
        
        return results
    }
    
    /**
    存在可能かどうか:
    存在条件を満たしている、または分割した結果、
    分割された各viewが存在条件を満たせば存在可能。
    */
    func validate(frame: CGRect, count: Int) -> Bool {
        // 最小幅制限
        if frame.size.width < Const.minWidth {
            println("\(count)最小幅制限")
            return false
        }
        // 最小高さ制限
        if frame.size.height < Const.minHeight {
            println("\(count)最小高さ制限")
            return false
        }
        // 最小面積制限
        if frame.size.width * frame.size.height < Const.minArea {
            println("\(count)最小面積制限")
            return false
        }
        // 最大面積よりも小さいかどうか
        if frame.size.width * frame.size.height <= Const.maxArea {
        }
        // 分割可能かどうか
        if count == 0 || self.dividableDirections(frame, count: count).count > 0 {
            return true
        } else {
            println("\(count)分割不能")
            // 縦横比制限
            if frame.size.height > frame.size.width * Const.maxPortion {
                println("\(count)縦横比制限")
                return false
            }
        }
        
        return true
    }
    
    /**
    画像とテキストの配置位置やサイズの決定
    */
    func setupTypes(title:String) {
        
        let verticallyImgArea   = self.getImgAreaTypeVertically()
        let horizontallyImgArea = self.getImgAreaTypeHorizontally()
        
        if verticallyImgArea.0 > horizontallyImgArea.0 {
            self.arrangeType = .Vertically
            self.imageType   = verticallyImgArea.1
            self.imgFrame    = verticallyImgArea.2
        } else {
            self.arrangeType = .Horizontally
            self.imageType   = horizontallyImgArea.1
            self.imgFrame    = horizontallyImgArea.2
        }
    }
    
    /**
    コンテンツを垂直に配置した場合の最も大きな画像のサイズのパターン
    */
    func getImgAreaTypeVertically() -> (CGFloat, ImageType, CGRect) {
        var inFrame = self.frame.rectByInsetting(dx: Const.contentsPadding, dy: Const.contentsPadding)
        inFrame.size.height -= Const.footerMarginBottom + Const.footerHeight

        var minLabelHeight = Const.minLabelAreaToShowImage / inFrame.size.width
        if minLabelHeight < Const.minLabelHeightToShowImage {
            minLabelHeight = Const.minLabelHeightToShowImage
        }
        var imgFrame = inFrame.rectsByDividing(minLabelHeight + Const.contentsPadding, fromEdge: .MaxYEdge).0
        
        var iconArea:CGFloat = 0
        if imgFrame.size.height > imgFrame.size.width {
            iconArea = imgFrame.size.width * imgFrame.size.width
        } else {
            iconArea = imgFrame.size.height * imgFrame.size.height
        }
        var bannerArea:CGFloat = 0
        if imgFrame.size.height > imgFrame.size.width * Const.bannerPortion {
            bannerArea = imgFrame.size.width * (imgFrame.size.width * Const.bannerPortion)
        } else {
            bannerArea = imgFrame.size.height * (imgFrame.size.height / Const.bannerPortion)
        }
        
        // 面積の大きい方をリターン
        if iconArea > bannerArea {
            return (iconArea, .Icon, imgFrame)
        } else {
            return (bannerArea, .Banner, imgFrame)
        }
        
    }
    
    /**
    コンテンツを水平に配置した場合の最も大きな画像のサイズのパターン
    */
    func getImgAreaTypeHorizontally() -> (CGFloat, ImageType, CGRect) {
        var inFrame = self.frame.rectByInsetting(dx: Const.contentsPadding, dy: Const.contentsPadding)
        inFrame.size.height -= Const.footerMarginBottom + Const.footerHeight
        
        var minLabelWidth = Const.minLabelAreaToShowImage / (self.frame.size.height - Const.contentsPadding - Const.footerMarginBottom - Const.footerHeight)
        if minLabelWidth < Const.minLabelWidthToShowImage {
            minLabelWidth = Const.minLabelWidthToShowImage
        }
        var imgFrame = inFrame.rectsByDividing(minLabelWidth + Const.contentsPadding, fromEdge: .MaxXEdge).0
        
        var iconArea:CGFloat = 0
        if imgFrame.size.height > imgFrame.size.width {
            iconArea = imgFrame.size.width * imgFrame.size.width
        } else {
            iconArea = imgFrame.size.height * imgFrame.size.height
        }
        var bannerArea:CGFloat = 0
        if imgFrame.size.height > imgFrame.size.width * Const.bannerPortion {
            bannerArea = imgFrame.size.width * (imgFrame.size.width * Const.bannerPortion)
        } else {
            bannerArea = imgFrame.size.height * (imgFrame.size.height / Const.bannerPortion)
        }
        
        // 面積の大きい方をリターン
        if iconArea > bannerArea {
            return (iconArea, .Icon, imgFrame)
        } else {
            return (bannerArea, .Banner, imgFrame)
        }
        
    }

//    /**
//    画像を配置する場所の決定
//    */
//    func decidePositionType() -> PositionType {
//        let width = view.frame.size.width
//        let height = view.frame.size.height - self.footerHeight
//        
//        var type:PositionType = .TEXT_ONLY
//        
//        // 画像とテキストを縦に並べる場合
//        if height > width {
//            
//            if let vpt = decidePositionTypeVertical(width, height) {
//                return vpt
//            } else {
//                if let hpt = decidePositionTypeHorizontal(width, height){
//                    return hpt
//                }
//            }
//            
//        } else {
//            
//            if let hpt = decidePositionTypeHorizontal(width, height){
//                return hpt
//            } else {
//                if let vpt = decidePositionTypeVertical(width, height) {
//                    return vpt
//                }
//            }
//            
//        }
//        return .TEXT_ONLY
//    }
//    
//    /**
//    画像を配置する場所の決定（縦）
//    */
//    func decidePositionTypeVertical(width:CGFloat, _ height:CGFloat) -> PositionType? {
//        
//        // アイコンを配置した場合のラベルの面積
//        var h = height - width
//        if h > self.minLabelHeightToShowImage && h * width > self.minLabelAreaToShowImage {
//            return .ICON_TOP_TEXT_BOTTOM
//        }
//        
//        h = height - width * self.smallImagePortion
//        if h > self.minLabelHeightToShowImage && h * width > self.minLabelAreaToShowImage {
//            return .SMALL_ICON_TOP_TEXT_BOTTOM
//        }
//        
//        // バナーを配置した場合のラベルの面積
//        h = height - width * bannerPortion
//        if h > self.minLabelHeightToShowImage && h * width > self.minLabelAreaToShowImage {
//            return .IMAGE_TOP_TEXT_BOTTOM
//        }
//        
//        // スモールバナーを配置した場合のラベルの面積
//        h = height - width * bannerPortion * self.smallImagePortion
//        if h > self.minLabelHeightToShowImage && h * width > self.minLabelAreaToShowImage {
//            return  .SMALL_IMAGE_TOP_TEXT_BOTTOM
//        }
//        return nil
//    }
//    
//    /**
//    画像を配置する場所の決定（横）
//    */
//    func decidePositionTypeHorizontal(width:CGFloat, _ height:CGFloat) -> PositionType? {
//        
//        // バナーを配置した場合のラベルの面積
//        var w = width - height / bannerPortion
//        if w > self.minLabelWidthToShowImage && w * height > self.minLabelAreaToShowImage {
//            return arc4random_uniform(2) < 1 ? .IMAGE_LEFT_TEXT_RIGHT : .IMAGE_RIGHT_TEXT_LEFT
//        }
//        
//        // アイコンを配置した場合のラベルの面積
//        w = width - height
//        if w > self.minLabelWidthToShowImage && w * height > self.minLabelAreaToShowImage {
//            return arc4random_uniform(2) < 1 ? .ICON_LEFT_TEXT_RIGHT : .ICON_RIGHT_TEXT_LEFT
//        }
//        
//        // スモールアイコンを配置した場合のラベルの面積
//        w = width - height * self.smallImagePortion
//        if w > self.minLabelWidthToShowImage && w * height > self.minLabelAreaToShowImage {
//            return arc4random_uniform(2) < 1 ? .SMALL_ICON_LEFT_TEXT_RIGHT : .SMALL_ICON_RIGHT_TEXT_LEFT
//        }
//        return nil
//    }
//    
//    func isHorizontalSmallIcon() -> Bool {
//        let icons:[PositionType] = [
//            .SMALL_ICON_LEFT_TEXT_RIGHT,
//            .SMALL_ICON_RIGHT_TEXT_LEFT
//        ]
//        return contains(icons, self.positionType)
//    }
//    
//    func isVerticalSmallImg() -> Bool {
//        let imgs:[PositionType] = [
//            .SMALL_ICON_TOP_TEXT_BOTTOM,
//            .SMALL_IMAGE_TOP_TEXT_BOTTOM
//        ]
//        return contains(imgs, self.positionType)
//    }
    
}