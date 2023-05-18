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
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.receive(on: DispatchQueue.main)
            .sink { [weak self] input in
                switch input {
                case .viewApear:
                    self?.viewApear()
                }
            }
            .store(in: &bag)
        return output.eraseToAnyPublisher()
    }
    private func viewApear() {
        let list = storage.getRecordData()
    }
}


extension HomeViewModel {
    enum Input {
        case viewApear
    }
    enum Output {
        case listOfRecordTapped
    }
}
