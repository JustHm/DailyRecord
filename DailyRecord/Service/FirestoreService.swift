//
//  FirestoreService.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/17.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


final class FirestoreService {
    private let firestore: Firestore = Firestore.firestore()
    private let uid: String
    
    init() {
        self.uid = Auth.auth().currentUser!.uid
    }
    
    func addData(data: [String: Any]) {
        firestore.collection("Records").document(uid)
            .collection(Date().toString(format: "yyyy.MM"))
            .addDocument(data: data)
    }
    
    func updateData(dateWithoutDay: String, documentID: String, data: [String: Any]) {
        let ref = firestore.collection("Records").document(uid).collection(dateWithoutDay).document(documentID)
        ref.updateData(data)
    }
    
    func deleteData(dateWithoutDay: String, documentID: String) async throws {
        let ref = firestore.collection("Records").document(uid).collection(dateWithoutDay).document(documentID)
        try await ref.delete()
    }
    
    func getData(date: String, descending: Bool) async throws -> [Article] {
        var result: [Article] = []
        let ref = firestore.collection("Records").document(uid).collection(date)
        let snapshot = try await ref.order(by: "date", descending: descending).getDocuments()
        
        for document in snapshot.documents {
            if let date = document["date"] as? String,
               let weather = document["weather"] as? String,
               let text = document["text"] as? String
            {
                //imagesURL은 Optional로 처리
                let data = Article(documentID: document.documentID,
                                   text: text,
                                   date: date,
                                   weather: weather,
                                   imagesURL: (document["imagesURL"] as? [String]) ?? [])
                result.append(data)
            }
        }
        return result
    }
}
