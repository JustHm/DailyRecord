//
//  ImageViewModel.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/27.
//
import Combine
import SwiftUI
import PhotosUI

@MainActor
final class ImageViewModel: ObservableObject {
    @Published var state: State = .upload
    @Published var imageUrl: [String] = []
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            Task {
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
    private let storage = StorageService()
    
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
    
    enum State {
        case upload
        case none
        case error(msg: String)
    }
}
