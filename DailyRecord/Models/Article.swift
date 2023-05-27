//
//  Article.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/16.
//

import Foundation

struct Article: Hashable {
    let documentID: String?
    var text: String
    let date: String // format yyyy.MM.dd
    var weather: String // SF Symbols name
    var imagesURL: [String]
    
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
