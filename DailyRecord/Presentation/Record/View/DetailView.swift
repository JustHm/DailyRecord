//
//  DetailView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/23.
//

import SwiftUI
import Combine

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    let input: PassthroughSubject<HomeViewModel.Input, Never>
    @State var article: Article
    @State var showUpdateAlert: Bool = false
    @StateObject var imageViewModel = ImageViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ArticleHeaderView(date: article.date, weather: $article.weather)
                
                ImagePageView(viewModel: imageViewModel, articleDate: article.date)
                
                TextField("여기에 입력하세요.", text: $article.text, axis: .vertical)
                    .frame(maxWidth: .infinity, minHeight: 200.0 , maxHeight: .infinity)
                    .font(.body)
                    .lineSpacing(8.0)
                    .foregroundColor(.white)
                    .toolbarRole(.editor)
                    .padding()
            }
        }
        .background(Color("CustomBackground"))
        .alert("Failed",
               isPresented: $showUpdateAlert,
               actions: { Button("확인", action: {showUpdateAlert.toggle()}) },
               message: { Text("오늘의 기록만 수정할 수 있습니다!") }
        )
        .toolbar {
            ToolbarItem {
                Menu {
                    Button(role: .destructive) {
                        input.send(.deleteArticle(article: article))
                        dismiss()
                    } label: {
                        Label("삭제", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .foregroundColor(.white)
            }
        }
        .onAppear {
            imageViewModel.imageUrl = article.imagesURL
        }
        .onChange(of: article, perform: { newValue in
            if Date().toString() != article.date {
                showUpdateAlert.toggle()
            }
        })
        .onDisappear {
            if Date().toString() == article.date {
                article.imagesURL = imageViewModel.imageUrl
                input.send(.setArticle(article: article))
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(input: .init(), article: Article(documentID: nil,text: "HI HI", date: Date().toString(), weather: .sunny, imagesURL: []))
    }
}
