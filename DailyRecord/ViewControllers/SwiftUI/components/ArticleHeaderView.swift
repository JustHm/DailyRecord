//
//  ArticleHeaderView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/26.
//

import SwiftUI

struct ArticleHeaderView: View {
    let date: String
    @Binding var weather: String
    var body: some View {
        HStack {
            Spacer()
            Text(date)
                .font(.title)
                .foregroundColor(.white)
            Spacer()
            Divider().background(.white).frame(maxHeight: 50.0)
            Spacer()
            Menu {
                Picker(selection: $weather, label: Text("Sorting options")) {
                    Label("맑음", systemImage: "sun.max.fill")
                        .tag("sun.max.fill")
                    Label("조금흐림", systemImage: "cloud.sun.fill")
                        .tag("cloud.sun.fill")
                    Label("흐림", systemImage: "smoke.fill")
                        .tag("smoke.fill")
                    Label("비", systemImage: "cloud.rain.fill")
                        .tag("cloud.rain.fill")
                    Label("눈", systemImage: "cloud.snow.fill")
                        .tag("cloud.snow.fill")
                }
            } label: {
                Image(systemName: weather)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64.0, height: 64.0)
            }
            .foregroundColor(.white)
            Spacer()
        }
        .padding()
        
        Divider().background(.white)
    }
}

struct ArticleHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleHeaderView(date: "", weather: .constant(""))
    }
}
