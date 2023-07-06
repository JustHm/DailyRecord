//
//  Date+.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/24.
//

import Foundation

extension Date {
    /// return Date to String in yyyy.MM.dd (default)
    /// - Parameter format: format string (default: yyyy.MM.dd)
    /// - Returns: String of Date 
    func toString(format: String = "yyyy.MM.dd") -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
}
