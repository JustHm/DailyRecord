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
    
    func addRecordData(data: [String: Any]) {
        storage.collection("Records").document(uid)
            .collection(Date().toString(format: "yyyy.MM"))
            .addDocument(data: data)
    }
    
    func updateRecordData(data: [String: Any]) {

    }
    
    func getRecordData(date: String, descending: Bool) async throws -> [Article] {
        var result: [Article] = []
        let ref = storage.collection("Records").document(uid).collection(date)
        let snapshot = try await ref.order(by: "date", descending: descending).getDocuments()
        
        for document in snapshot.documents {
            if let date = document["date"] as? String,
               let weather = document["weather"] as? String,
               let text = document["text"] as? String
            {
                let data = Article(text: text,
                                   date: date,
                                   weather: weather)
                result.append(data)
            }
        }
        return result
    }
}
