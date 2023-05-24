//
//  DetailView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/23.
//

import SwiftUI

struct DetailView: View {
    let article: Article
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(article.date)
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
                Divider().background(.white).frame(maxHeight: 50.0)
                Spacer()
                Image(systemName: article.weather)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64.0, height: 64.0)
            }
            .padding()
            
            Divider().background(.white)
            
            Text(article.text)
                .font(.body)
                .lineSpacing(8.0)
                .foregroundColor(.white)
                .padding()
            Spacer()
        }
        .padding()
        .background(Color("CustomBackground"))
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(article: Article(text: "HI HI", date: Date().toString(), weather: "sun.max.fill"))
    }
}
