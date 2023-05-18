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
        storage.collection("Records").document(uid).collection("Record").addDocument(data: data)
    }
    
    func getRecordData() -> [Article] {
//        storage.collection("record").document(uid).collection("Record").getDocuments
            
//            .getDocuments { snapshot, error in
//            if let error { return }
////            snapshot
//        }
        return []
    }
    
    private func addImages(images: [UIImage]) async throws {
        
    }
    
    private func getImages() {
    
    }
    
}
