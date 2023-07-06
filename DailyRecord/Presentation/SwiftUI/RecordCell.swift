//
//  RecordCell.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/18.
//

import SwiftUI

struct RecordCell: View {
    let title: String
    let date: Date
    
    var body: some View {
        HStack {
            Text(title)
                .lineLimit(1)
                .font(.title)
            Spacer()
            Text(date, style: .date)
                .font(.caption)
        }
        .padding()
        .background(Color.green)
    }
}

struct RecordCell_Previews: PreviewProvider {
    static var previews: some View {
        RecordCell(title: "HELLO", date: Date())
            .previewLayout(.sizeThatFits)
    }
}
