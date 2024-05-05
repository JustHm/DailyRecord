//
//  ImageViewModel.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/27.
//
import Combine
import SwiftUI
import PhotosUI
//enum에 input value가 있을 경우 비교할 땐 Equatable이 필요함
enum StorageState: Equatable {
    case upload
    case none
    case error(msg: String)
}

@MainActor
final class ImageViewModel: ObservableObject {
    @Published var state: StorageState = .none
    @Published var imageUrl: [String] = []
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            Task {
                if !selectedItems.isEmpty {
                    do {
                        state = .upload
                        try await self.transferable()
                        selectedItems = []
                        state = .none
                    } catch {
                        state = .error(msg: error.localizedDescription)
                    }
                }
            }
        }
    }
    private let storage = DefaultImageStorage()
    
    func transferable() async throws {
        var images: [Data] = []
        for selectedItem in selectedItems {
            guard let data = try await selectedItem.loadTransferable(type: Data.self)
            else { continue }
            images.append(data)
        }
        let result = try await storage.uploadImages(images)
        imageUrl.append(contentsOf: result)
    }
}
