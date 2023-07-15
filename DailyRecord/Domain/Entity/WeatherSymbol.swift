//
//  WeatherSymbol.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/07/10.
//

import Foundation

enum WeatherSymbol: String, CaseIterable {
    case sunny = "sun.max.fill"
    case cloudy = "cloud.sun.fill"
    case rain = "cloud.rain.fill"
    case snow = "cloud.snow.fill"
    
    var name: String {
        switch self {
        case .sunny: return "맑음"
        case .cloudy: return "흐림"
        case .rain: return "비"
        case .snow: return "눈"
        }
    }
}
