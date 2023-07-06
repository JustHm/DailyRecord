//
//  InfoView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/25.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Daily Record")
                .font(.largeTitle)
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            Divider().background(.white)
            
            Text("\"Write about your day\"")
                .font(.title3)
                .foregroundColor(.white)
                .padding(.bottom, 16.0)
            Text("""
This app can only add today's record, and it can modify the record but only for today's record
""")
            .font(.body)
            .foregroundColor(.white)
            
            Spacer()
        }
        .padding()
        .background(Color("CustomBackground"))
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
