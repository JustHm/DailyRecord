//
//  StorageService.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/17.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift


final class StorageService {
    private let storage: Firestore = Firestore.firestore()
    private let imageDB: Storage = Storage.storage()
    private let uid: String
    
    init() {
        self.uid = Auth.auth().currentUser!.uid
    }
    
    func addRecordData(data: [String: Any], images: [UIImage]) {
//        addImages(images: images)
        storage.collection("Records").document(uid)
            .collection(Date().toString(format: "yyyy.MM"))
            .addDocument(data: data)
    }
    
    func getRecordData(date: String) async throws -> [Article] {
        var result: [Article] = []
        let ref = storage.collection("Record").document(uid).collection(date)
        let snapshot = try await ref.order(by: "timestamp", descending: true).getDocuments()
        
        for document in snapshot.documents {
            if let date = document["date"] as? String,
               let weather = document["weather"] as? String,
               let text = document["text"] as? String
            {
                let data = Article(imagesURL: (document["imagesURL"] as? [String]) ?? [],
                                   text: text,
                                   date: date,
                                   weather: weather)
                result.append(data)
            }
        }
        return result
    }
    
    private func addImages(images: [UIImage]) async throws {
        
    }
    
    private func getImages() {
    
    }
    
}
