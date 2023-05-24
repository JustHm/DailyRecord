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
                case .addArticle(let article):
                    self?.setData(article: article)
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
            getData()
        }
    }
    private func getData() {
        output.send(.listFilter(date: currentDate))
        Task {
            do {
                let list = try await storage.getRecordData(date: currentDate)
                output.send(.setCellData(data: list))
            } catch {
                output.send(.showAlert(msg: "데이터 가져오기 실패"))
            }
        }
    }
    func setData(article: Article) {
        storage.addRecordData(data: article.dictionary)
        getData()
    }
}


extension HomeViewModel {
    enum Input {
        case viewApear
        case prevFilter
        case nextFilter
        case addArticle(article: Article)
    }
    enum Output {
        case listFilter(date: String)
        case setCellData(data: [Article])
        case showAlert(msg: String)
    }
}
