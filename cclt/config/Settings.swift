//
//  Settings.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/6/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)

enum Settings {
    
    static let maxHistorySearchWords = 30
    static let loadingGif = UIImage(named: "loading")
    static let twitterAccount = "chocolat_cclt"
    
    static let partytrackAppID:Int32 = 4423
    static let partytrackAppKey = "f0337712425d5476a6243d2268675c59"
    
    // チュートリアル
    enum Tutorials:Int {
        case SwipeToNext = 1
        case BackToTop   = 2
        
        func isFinished() -> Bool {
            let ud = NSUserDefaults.standardUserDefaults()
            return ud.boolForKey("Tutorial\(self.rawValue)")
        }
        
        func finish() {
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setBool(true, forKey: "Tutorial\(self.rawValue)")
            ud.synchronize()
        }
    }
    
    // フォント
    enum Fonts {
        
        static let tabFont = UIFont(name:"HelveticaNeue-Bold", size:10.0)
        
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
            return UIFont(descriptor: fontDescriptor, size: fontSize)
        }
        
        static let minimumFont = UIFont.systemFontOfSize(11.0)
        static let smallFont   = UIFont.systemFontOfSize(12.0)
        static let mediumFont  = UIFont.systemFontOfSize(14.0)
        static let largeFont   = UIFont.systemFontOfSize(15.0)
        
        static let titleMinimumFont = UIFont.boldSystemFontOfSize(12.0)
        static let titleSmallFont   = UIFont.boldSystemFontOfSize(13.0)
        static let titleFont        = UIFont.boldSystemFontOfSize(14.0)
        
        static let headlineSmallFont  = UIFont.boldSystemFontOfSize(16.0)
        static let headlineMediumFont = UIFont.boldSystemFontOfSize(18.0)
        static let headlineLargeFont  = UIFont.boldSystemFontOfSize(20.0)
        
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
        
        static let tutorialGrayColor      = UIColor("#000000", 0.5)
        static let tutorialLightGrayColor = UIColor("#000000", 0.1)

        static let tabBackgroundColor    = UIColor("#effef8", 1.0)
        static let tabTintColor          = UIColor("#40a981", 1.0)
        static let tabTitleColor         = UIColor("#626363", 1.0)
        static let selectedTabTitleColor = UIColor("#40a981", 1.0)
        
        static let curatorColor = UIColor("#999999", 1.0)  // キュレーター
        static let chocoColor = UIColor("#41b796", 1.0)  // チョコ
        
        static let linkColor = UIColor("#41b796", 1.0)       // リンク（chocoと一緒）
        static let sourceLinkColor = UIColor("#464646", 1.0) // 引用リンク
        static let quotationColor = UIColor("#464646", 1.0)  // 引用文
        
        static let infoBackgroundColor = UIColor("#effbff", 0.75)  // 導入背景
        
        static let headlineRedColor = UIColor("#ff0000", 1.0)
        static let headlineGreenColor = UIColor("#92e1c4", 1.0)
        static let headlineBlueColor = UIColor("#0000ff", 1.0)
        
        static let twitterColor = UIColor("#55acee", 1.0)
        
        static let twitterBackgroundColor = UIColor("#fafafa", 0.60)
        
    }
    
}