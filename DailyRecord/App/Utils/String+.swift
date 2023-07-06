//
//  String+.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/24.
//

import Foundation

extension String {
    func toDate(format: String = "yyyy.MM.dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
