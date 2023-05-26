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
    private var sortFilter: Bool = true
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.receive(on: DispatchQueue.main)
            .sink { [weak self] input in
                switch input {
                case .viewApear:
                    self?.getData()
                case .prevFilter:
                    self?.monthFilter(adding: -1)
                case .nextFilter:
                    self?.monthFilter(adding: 1)
                case .sortFilter:
                    self?.sortFilter.toggle()
                    self?.getData()
                //여긴 HomeVC 아님
                case .addArticle(let article):
                    self?.setData(article: article)
                case .deleteArticle(let article):
                    self?.deleteData(article: article)
                }
            }
            .store(in: &bag)
        return output.eraseToAnyPublisher()
    }
    private func monthFilter(adding: Int) {
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
                let list = try await storage.getData(date: currentDate, descending: sortFilter)
                output.send(.setCellData(data: list))
                output.send(.sortState(descending: sortFilter))
            } catch {
                output.send(.showAlert(msg: "데이터 가져오기 실패"))
            }
        }
    }
    
    /// Add Article Or Update Article ( Update Trigger: document ID is not optional )
    /// - Parameter article: article
    func setData(article: Article) {
        if let id = article.documentID,
           let date = article.date.toDate()?.toString(format: "yyyy.MM") {
            storage.updateData(dateWithoutDay: date,
                                     documentID: id,
                                     data: article.dictionary
            )
        }
        else {
            storage.addData(data: article.dictionary)
        }
        
        getData()
    }
    
    func deleteData(article: Article) {
        guard let id = article.documentID,
              let date = article.date.toDate()?.toString(format: "yyyy.MM") else {
            output.send(.showAlert(msg: "Delete Failed"))
            return
        }
        Task {
            do {
                try await storage.deleteData(dateWithoutDay: date, documentID: id)
                getData()
            } catch {
                output.send(.showAlert(msg: "Delete Failed"))
            }
        }
    }
}


extension HomeViewModel {
    enum Input {
        case viewApear
        case prevFilter
        case nextFilter
        case sortFilter
        // AddView만 사용
        case addArticle(article: Article)
        // DetailView만 사용
        case deleteArticle(article: Article)
    }
    enum Output {
        case setCellData(data: [Article])
        case listFilter(date: String)
        case sortState(descending: Bool)
        case showAlert(msg: String)
    }
}
