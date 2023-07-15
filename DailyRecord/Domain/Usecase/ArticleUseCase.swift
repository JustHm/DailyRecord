//
//  ArticleUsecase.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/07/10.
//
import Combine
import Foundation

protocol ArticleUseCase {
    func fetchData(date: String, descending: Bool) -> Future<[Article], Error>
    func uploadArticle(data: [String: Any])
    func updateArticle(dateWithoutDay: String, documentID: String, data: [String: Any])
    func deleteData(dateWithoutDay: String, documentID: String) async throws
}

class DefaultArticleUseCase: ArticleUseCase {
    private let articleRepository: ArticleRepository
    
    init(articleRepository: ArticleRepository) {
        self.articleRepository = articleRepository
    }
    
    func fetchData(date: String, descending: Bool) -> Future<[Article], Error> {
        return articleRepository.fetchData(date: date, descending: descending)
    }
    
    func uploadArticle(data: [String : Any]) {
        articleRepository.uploadData(data: data)
    }
    func updateArticle(dateWithoutDay: String, documentID: String, data: [String : Any]) {
        articleRepository.updateData(
            dateWithoutDay: dateWithoutDay,
            documentID: documentID,
            data: data
        )
    }
    
    func deleteData(dateWithoutDay: String, documentID: String) async throws {
        try await articleRepository.deleteData(
            dateWithoutDay: dateWithoutDay,
            documentID: documentID
        )
    }
    
}
