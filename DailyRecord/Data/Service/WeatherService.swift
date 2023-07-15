//
//  WeatherService.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/18.
//

import Foundation

struct WeatherService {
    private func getCurrentLocationWeather() async throws -> Data {
        let url = URL(string: "www.weather.com")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw CocoaError(.fileLocking) }
        
        return data
    }
}
