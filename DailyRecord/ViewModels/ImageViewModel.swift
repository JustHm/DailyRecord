//
//  ImageViewModel.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/27.
//
import Combine
import SwiftUI
import PhotosUI
import CoreTransferable

@MainActor
final class ImageViewModel: ObservableObject {
    @Published var state: State = .upload
    @Published var imageUrl: [String] = []
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            state = .upload
            Task {
                do {
                try await self.transferable()
                } catch {
                    print("HM-DEBUG\(error.localizedDescription)")
                }
            }
        }
    }
    private let storage = StorageService()
    
    func transferable() async throws {
        var images: [Data] = []
        for selectedItem in selectedItems {
            guard let data = try await selectedItem.loadTransferable(type: Data.self)
            else { continue }
            images.append(data)
        }
        imageUrl = try await storage.uploadImages(images)
        state = .none
    }
    
    enum State {
        case upload
        case none
    }
}
