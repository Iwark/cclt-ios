//
//  SummaryContent.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/10/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ContentType:String {
    case Text = "text"
    case Image = "image"
    case Quotation = "quotation"
    case Headline = "headline"
    case Link = "link"
    case Twitter = "twitter"
    case Commodity = "commodity"
    case Movie = "movie"
}

// MARK: - Text

class ContentText {
    
    enum FontSize:String {
        case Small = "small"
        case Medium = "medium"
        case Large = "large"
    }
    
    enum Style:String {
        case Normal = "normal"
        case Bold = "bold"
        case Italic = "italic"
        case BoldItalic = "bold_italic"
    }
    
    let id: Int
    let text: String
    let style: Style
    let fontSize: FontSize
    
    required internal init(_ json:JSON){
        self.id = json["id"].intValue
        self.text = json["text"].stringValue
        
        if let style = Style(rawValue: json["style"].stringValue){
            self.style = style
        } else {
            self.style = .Normal
        }
        
        if let fontSize = FontSize(rawValue: json["fontSize"].stringValue){
            self.fontSize = fontSize
        } else {
            self.fontSize = .Medium
        }
    }
}

// MARK: - Image

class ContentImage {
    let id: Int
    let image_url: String
    let text: String
    let source: String
    required internal init(_ json:JSON){
        self.id = json["id"].intValue
        self.image_url = json["image_url"].stringValue
        self.text = json["text"].stringValue
        self.source = json["source"].stringValue
    }
}

// MARK: - Quotation

class ContentQuotation {
    let id: Int
    let text: String
    let url: String
    required internal init(_ json:JSON){
        self.id = json["id"].intValue
        self.text = json["text"].stringValue
        self.url = json["url"].stringValue
    }
}

// MARK: - Headline

class ContentHeadline {
    enum FontSize:String {
        case Small = "small"
        case Medium = "medium"
        case Large = "large"
    }
    
    enum Color:String {
        case Red = "#f00"
        case Green = "#0f0"
        case Blue = "#00f"
    }
    
    let id: Int
    let text: String
    let color: Color?
    let fontSize: FontSize
    
    required internal init(_ json:JSON){
        self.id = json["id"].intValue
        self.text = json["text"].stringValue
        
        if let color = Color(rawValue: json["color"].stringValue){
            self.color = color
        }
        
        if let fontSize = FontSize(rawValue: json["fontSize"].stringValue){
            self.fontSize = fontSize
        } else {
            self.fontSize = .Medium
        }
    }
}

// MARK: - Link

class ContentLink {
    let id: Int
    let title: String
    let url: String
    let text: String
    let image_url: String
    let source: String
    required internal init(_ json:JSON){
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.url = json["url"].stringValue
        self.text = json["text"].stringValue
        self.image_url = json["image_url"].stringValue
        self.source = json["source"].stringValue
    }
}

// MARK: -  Twitter

class ContentTwitter {
    let id: Int
    let url: String
    let text: String
    let userName: String
    let profileImageURL: String
    let imageURL: String
    let statusID: String
    
    required internal init(_ json:JSON){
        self.id = json["id"].intValue
        self.url = json["url"].stringValue
        self.text = json["text"].stringValue
        self.userName = json["user_name"].stringValue
        self.profileImageURL = json["profile_image_url"].stringValue
        self.imageURL = json["image_url"].stringValue
        self.statusID = json["status_id"].stringValue
    }
    
}

// MARK: - Commodity

class ContentCommodity {
    let id: Int
    let name: String
    let url: String
    let text: String
    let price: Int
    let imageURL:String
    let source:String
    
    required internal init(_ json:JSON){
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.url = json["url"].stringValue
        self.text = json["text"].stringValue
        self.price = json["price"].intValue
        self.imageURL = json["image_url"].stringValue
        self.source = json["source"].stringValue
    }
}

// MARK: - Movie

class ContentMovie {
    
    let id: Int
    let url: String
    let text: String
    
    required internal init(_ json:JSON){
        self.id = json["id"].intValue
        self.text = json["text"].stringValue
        self.url = json["url"].stringValue
    }
    
    
}