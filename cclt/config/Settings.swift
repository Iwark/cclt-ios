//
//  Settings.swift
//  cclt
//
//  Created by Kohei Iwasaki on 1/6/15.
//  Copyright (c) 2015 Donuts. All rights reserved.
//

import UIKit

enum Settings {
    
    // フォント
    enum Fonts {
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
        
        static let linkColor = UIColor("#41b796", 1.0)  // リンク（chocoと一緒）
        static let quotationColor = UIColor("#464646", 1.0)  // 引用文
        
        static let infoBackgroundColor = UIColor("#effbff", 0.75)  // 導入背景
        
        static let headlineRedColor = UIColor("#ff0000", 1.0)
        static let headlineGreenColor = UIColor("#00ff00", 1.0)
        static let headlineBlueColor = UIColor("#0000ff", 1.0)
        
        static let twitterColor = UIColor("#55acee", 1.0)
    }
    
}