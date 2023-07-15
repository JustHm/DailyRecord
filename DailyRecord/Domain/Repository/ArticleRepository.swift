//
//  ArticleRepository.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/07/10.
//
import Combine
import Foundation

protocol ArticleRepository {
    func uploadData(data: [String: Any])
    func updateData(dateWithoutDay: String, documentID: String, data: [String: Any])
    func deleteData(dateWithoutDay: String, documentID: String) async throws
    func fetchData(date: String, descending: Bool) -> Future<[Article], Error>
}
