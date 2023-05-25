//
//  DetailView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/23.
//

import SwiftUI
import Combine

struct DetailView: View {
    let article: Article
    let input: PassthroughSubject<HomeViewModel.Input, Never>
    @Environment(\.dismiss) var dismiss
    
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
        .toolbar {
            ToolbarItem {
                Menu {
                    Button(role: .none) {
                        print("dd")
                    } label: {
                        Label("Update", systemImage: "pencil")
                    }

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
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(article: Article(documentID: nil,text: "HI HI", date: Date().toString(), weather: "sun.max.fill"), input: .init())
    }
}
