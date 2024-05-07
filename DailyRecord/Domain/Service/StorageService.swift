//
//  DefaultImageStorage.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/27.
//
import Foundation
import FirebaseAuth
import FirebaseStorage

protocol StorageService {
    func uploadImages(image: [Data]) async throws -> [String]
}

final class DefaultStorageService: StorageService {
    private let repository: StorageRepository = DefaultStorageRepository()
    
    func uploadImages(image: [Data]) async throws -> [String] {
        return try await repository.uploadImages(image)
    }
    
}
