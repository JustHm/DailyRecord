//
//  Article.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/16.
//

import Foundation

struct Article: Codable {
    let imagesURL: [String]
    let text: String
    let date: String // format yyyy.MM.dd
    let weather: String // SF Symbols name
    
    var dictionary: [String: Any] {
        get {
            [
                "date": date,
                "weather": weather,
                "text": text,
                "imagesURL": imagesURL
            ]
        }
    }
}
