//
//  DetailView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/23.
//

import SwiftUI
import Combine

struct DetailView: View {
    let input: PassthroughSubject<HomeViewModel.Input, Never>
    @State var article: Article
    @State var showUpdateAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    @StateObject var imageViewModel = ImageViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ArticleHeaderView(date: article.date, weather: $article.weather)
                
                ImagePageView(viewModel: imageViewModel)
                
                TextField("Input here", text: $article.text, axis: .vertical)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .font(.body)
                    .lineSpacing(8.0)
                    .foregroundColor(.white)
                    .padding()
                
            }
        }
        .background(Color("CustomBackground"))
        .alert("Failed",
               isPresented: $showUpdateAlert,
               actions: { Button("OK", action: {showUpdateAlert.toggle()}) },
               message: { Text("You can only modify today's record") }
        )
        .toolbar {
            ToolbarItem {
                Menu {
                    Button(role: .destructive) {
                        input.send(.deleteArticle(article: article))
                        dismiss()
                    } label: {
                        Label("Delete", systemImage: "trash")
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
                input.send(.addArticle(article: article))
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(input: .init(), article: Article(documentID: nil,text: "HI HI", date: Date().toString(), weather: "sun.max.fill", imagesURL: []))
    }
}
