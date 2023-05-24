//
//  HomeViewModel.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/18.
//
import Combine
import Foundation

final class HomeViewModel {
    private var bag = Set<AnyCancellable>()
    private let output: PassthroughSubject<Output, Never> = .init()
    private let storage = StorageService()
    private var currentDate: String = Date().toString(format: "yyyy.MM")
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.receive(on: DispatchQueue.main)
            .sink { [weak self] input in
                switch input {
                case .viewApear:
                    self?.getData()
                case .prevFilter:
                    self?.setFilter(adding: -1)
                case .nextFilter:
                    self?.setFilter(adding: 1)
                }
            }
            .store(in: &bag)
        return output.eraseToAnyPublisher()
    }
    private func setFilter(adding: Int) {
        guard let date = currentDate.toDate(format: "yyyy.MM") else { return }
        
        var dateComponent = DateComponents()
        dateComponent.month = adding
        
        // 이거 true로 하면 달만 바뀜 년도 안 바뀜
        if let caculateDate = Calendar.current.date(byAdding: dateComponent, to: date, wrappingComponents: false) {
            let dateToString = caculateDate.toString(format: "yyyy.MM")
            currentDate = dateToString
            output.send(.listFilter(date: dateToString))
        }
    }
    private func getData() {
        output.send(.listFilter(date: currentDate))
        Task {
            do {
                let list = try await storage.getRecordData(date: Date().toString(format: "yyyy.MM"))
    //            output.send(.setCellData(data: list))
            } catch {
                
            }
        }
        let sampleData = [
            ArticlePreview(title: "A", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "B", date: Date(), weather: "sun.max.circle.fill"),
            ArticlePreview(title: "C", date: Date(), weather: "cloud.rain.circle.fill"),
            ArticlePreview(title: "D", date: Date(), weather: "cloud.sun.rain.fill"),
            ArticlePreview(title: "E", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "F", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "G", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "H", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "I", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "J", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "K", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "L", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "M", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "N", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "O", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "P", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "Q", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "R", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "S", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "T", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "U", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "V", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "W", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "X", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "Y", date: Date(), weather: "sun.max.fill"),
            ArticlePreview(title: "Z", date: Date(), weather: "sun.max.fill")
        ]
        output.send(.setCellData(data: sampleData))
    }
}


extension HomeViewModel {
    enum Input {
        case viewApear
        case prevFilter
        case nextFilter
    }
    enum Output {
        case listFilter(date: String)
        case setCellData(data: [ArticlePreview])
        case showAlert(msg: String)
    }
}
