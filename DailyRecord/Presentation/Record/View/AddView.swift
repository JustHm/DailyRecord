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
    @State var weather: WeatherSymbol = .sunny
    @StateObject var imageViewModel = ImageViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading) {
                ArticleHeaderView(date: Date().toString(), weather: $weather)
                
                ImagePageView(viewModel: imageViewModel, articleDate: Date().toString())
                
                TextField("여기에 입력하세요.", text: $text, axis: .vertical)
                    .font(.body)
                    .lineSpacing(8.0)
                    .foregroundColor(.white)
                    .padding()
                    .toolbarRole(.editor)
                Spacer()
            }
        }
        .overlay(content: {
            if imageViewModel.state == .upload {
                LoadingView()
            }
        })
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
                                           weather: weather,
                                           imagesURL: imageViewModel.imageUrl)
                        input.send(.setArticle(article: data))
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
