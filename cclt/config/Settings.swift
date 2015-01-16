//
//  Settings.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/6/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

enum Settings {
    
    static let maxHistorySearchWords = 30
    
    static let loadingGif = UIImage(named: "loading")
    
    // フォント
    enum Fonts {
        
        enum TextSizes:CGFloat {
            case Small = 12.0
            case Medium = 14.0
            case Large = 15.0
        }
        static func textFont(size:ContentText.FontSize, style:ContentText.Style) -> UIFont {
            var fontSize:CGFloat = 14.0
            switch size {
            case .Small:
                fontSize = 12.0
            case .Medium:
                break
            case .Large:
                fontSize = 17.0
            }
            
            var fontStyle = UIFontDescriptorSymbolicTraits()

//            var matrix = CGAffineTransformMake(1, 0, CGFloat(tanf(Float(M_PI) * 15 / 180)), 1, 0, 0)

            switch style {
            case .Normal:
                break
            case .Bold:
                fontStyle = UIFontDescriptorSymbolicTraits.TraitBold
            case .Italic:
                fontStyle = UIFontDescriptorSymbolicTraits.TraitItalic
            case .BoldItalic:
                fontStyle = UIFontDescriptorSymbolicTraits.TraitBold | UIFontDescriptorSymbolicTraits.TraitItalic
            }
            
            let label = UILabel()
            let fontDescriptor = label.font.fontDescriptor().fontDescriptorWithSymbolicTraits(fontStyle)
//            label.font.fontDescriptor().fontDescripto
            return UIFont(descriptor: fontDescriptor, size: fontSize)
        }
        
        static let minimumFont = UIFont.systemFontOfSize(11.0)
        static let smallFont   = UIFont.systemFontOfSize(12.0)
        static let mediumFont  = UIFont.systemFontOfSize(14.0)
        static let largeFont   = UIFont.systemFontOfSize(15.0)
        
        static let titleMinimumFont = UIFont.boldSystemFontOfSize(12.0)
        static let titleSmallFont   = UIFont.boldSystemFontOfSize(13.0)
        static let titleFont        = UIFont.boldSystemFontOfSize(14.0)
        
        static let headlineSmallFont  = UIFont.boldSystemFontOfSize(17.0)
        static let headlineMediumFont = UIFont.boldSystemFontOfSize(19.0)
        static let headlineLargeFont  = UIFont.boldSystemFontOfSize(21.0)
        
        enum IPad {
            static let navTitleFont = UIFont.boldSystemFontOfSize(22.0)
        }
    }
    
    // 色
    enum Colors {
        static let mainColor = UIColor("#92e1c4", 0.9)  // ショコラカラー
        static let backgroundColor = UIColor("#effbff", 1.0)  // 全体背景色
        static let borderLightColor = UIColor("#d4d4d4", 1.0).CGColor  // 薄い線
        static let textColor = UIColor("#333333", 1.0)  // デフォルト文字色
        static let tappedColor = UIColor("#cdcdcd", 0.8)  // タップ後の反転色

        static let curatorColor = UIColor("#999999", 1.0)  // キュレーター
        static let chocoColor = UIColor("#41b796", 1.0)  // チョコ
        
        static let linkColor = UIColor("#41b796", 1.0)       // リンク（chocoと一緒）
        static let sourceLinkColor = UIColor("#464646", 1.0) // 引用リンク
        static let quotationColor = UIColor("#464646", 1.0)  // 引用文
        
        static let infoBackgroundColor = UIColor("#effbff", 0.75)  // 導入背景
        
        static let headlineRedColor = UIColor("#ff0000", 1.0)
        static let headlineGreenColor = UIColor("#00ff00", 1.0)
        static let headlineBlueColor = UIColor("#0000ff", 1.0)
        
        static let twitterColor = UIColor("#55acee", 1.0)
        
        static let twitterBackgroundColor = UIColor("#fafafa", 0.60)
        
    }
    
}