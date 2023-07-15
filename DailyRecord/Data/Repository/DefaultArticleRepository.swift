//
//  DefaultArticleRepository.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/07/12.
//
import Combine
import Foundation
import FirebaseFirestoreSwift


final class DefaultArticleRepository {
    private let firestore: FirestoreStorage
    
    init(firestore: FirestoreStorage) {
        self.firestore = firestore
    }
}

extension DefaultArticleRepository: ArticleRepository {
    func fetchData(date: String, descending: Bool) -> Future<[Article], Error> {
        return Future<[Article], Error> { [weak self] promise in
            let a = self?.descending
//            Task { [data, descending] in
//                try await firestore.fetchData(date: data, descending: descending)
//            }
        }
    }
    
    
    func uploadData(data: [String : Any]) {
        firestore.addData(data: data)
    }
    
    func updateData(dateWithoutDay: String, documentID: String, data: [String : Any]) {
        firestore.updateData(dateWithoutDay: dateWithoutDay,
                             documentID: documentID,
                             data: data
        )
    }
    
    func fetchData(date: String, descending: Bool) async throws -> [Article] {
        return try await firestore.fetchData(date: date, descending: descending)
    }
    
    func deleteData(dateWithoutDay: String, documentID: String) async throws {
        try await firestore.deleteData(dateWithoutDay: dateWithoutDay,
                             documentID: documentID
        )
    }

    
}
