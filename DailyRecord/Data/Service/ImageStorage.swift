//
//  StorageService.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/27.
//
import Foundation
import FirebaseAuth
import FirebaseStorage

protocol ImageStorage {
    /// Upload Image Data to Firebase Storage and get downloadable URL ( Firebase Bucket URL -> DownloadURL )
    /// - Parameter images: UIImage as Data
    /// - Returns: Downloadable URL
    func uploadImages(_ images: [Data]) async throws -> [String]
}

final class DefaultImageStorage: ImageStorage {
    
    func uploadImages(_ images: [Data]) async throws -> [String] {
        let storage = Storage.storage().reference()
        var firebaseURL: [String] = []
        try await withThrowingTaskGroup(of: String.self, body: { group in
            let defaultPath = "\(Auth.auth().currentUser?.uid ?? "user")/images/\(Date().toString(format: "yyyy.MM.dd"))"
            for item in images {
                let ref = storage.child("\(defaultPath)/\(UUID()).png")
                group.addTask {
                    let metadata = try await ref.putDataAsync(item)
                    return "gs://\(metadata.bucket)/\(metadata.path ?? "none")"
                }
            }
            for try await url in group {
                firebaseURL.append(url)
            }
        })
        return try await uploadTaskGroup(firebaseURL: firebaseURL)
    }
    
    
    /// Get downloadable URL ( Firebase Bucket URL -> DownloadURL )
    /// - Parameter firebaseURL: Firebase Bucket URL
    /// - Returns: Downloadable URL
    private func uploadTaskGroup(firebaseURL: [String]) async throws -> [String] {
        var downloadURL: [String] = []
        try await withThrowingTaskGroup(of: URL?.self, body: { group in
            for item in firebaseURL {
                let ref = Storage.storage().reference(forURL: item)
                group.addTask {
                    return try await ref.downloadURL()
                }
            }
            
            for try await url in group {
                guard let url else { continue }
                downloadURL.append(url.absoluteString)
            }
        })
        
        return downloadURL
    }
}
