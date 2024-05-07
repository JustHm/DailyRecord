//
//  ArticleUsecase.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/07/10.
//
import Combine
import Foundation

protocol ArticleService {
    func fetchData(date: String, descending: Bool) async throws -> [Article]
    func uploadArticle(data: Article)
    func updateArticle(dateWithoutDay: String, documentID: String, data: Article)
    func deleteData(dateWithoutDay: String, documentID: String) async throws
}

class DefaultArticleService: ArticleService {
    private let articleRepository: ArticleRepository = DefaultArticleRepository()
    
    func fetchData(date: String, descending: Bool) async throws -> [Article]  {
        return try await articleRepository.fetchData(date: date, descending: descending)
    }
    
    func uploadArticle(data: Article) {
        articleRepository.addData(data: data.dictionary)
    }
    func updateArticle(dateWithoutDay: String, documentID: String, data: Article) {
        articleRepository.updateData(
            dateWithoutDay: dateWithoutDay,
            documentID: documentID,
            data: data.dictionary
        )
    }
    
    func deleteData(dateWithoutDay: String, documentID: String) async throws {
        try await articleRepository.deleteData(
            dateWithoutDay: dateWithoutDay,
            documentID: documentID
        )
    }
    
}
