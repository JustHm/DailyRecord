//
//  Article.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/16.
//

import Foundation

struct Article: Codable {
    let imagesURL: [String]
    let title: String
    let descibe: String
    let date: Date
}