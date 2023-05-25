//
//  AddView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/24.
//

import SwiftUI
import Combine

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    let input: PassthroughSubject<HomeViewModel.Input, Never>
    @State var text: String = ""
    @State var weather: String = "sun.max.fill"
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading) {
                HStack {
                    Text(Date().toString())
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
                }
                .padding()
                
                Divider().background(.white)
                
                TextField("input here", text: $text, axis: .vertical)
                    .font(.body)
                    .lineSpacing(8.0)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
        }
        .padding()
        .background(Color("CustomBackground"))
        .toolbar {
            ToolbarItem {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .onTapGesture {
                        let data = Article(documentID: nil,
                                           text: text,
                                           date: Date().toString(),
                                           weather: weather)
                        input.send(.addArticle(article: data))
                        UserDefaults.standard.set(Date().toString(), forKey: "LastAddDate")
                        dismiss()
                    }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(input: .init())
    }
}
