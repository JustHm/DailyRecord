//
//  ArticleHeaderView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/26.
//

import SwiftUI

struct ArticleHeaderView: View {
    let date: String
    @Binding var weather: WeatherSymbol
    var body: some View {
        VStack {
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
                        ForEach(WeatherSymbol.allCases, id: \.rawValue) { weather in
                            Label(weather.name, systemImage: weather.rawValue)
                                .tag(weather.name)
                        }
                    }
                } label: {
                    Image(systemName: weather.rawValue)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64.0, height: 64.0)
                }
                .foregroundColor(.white)
                Spacer()
            }
            Divider().background(.white)
        }
    }
}

struct ArticleHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleHeaderView(date: Date().toString(), weather: .constant(WeatherSymbol.cloudy))
            .background(Color("CustomBackground"))
    }
}
