//
//  HomeViewController.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/15.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = HomeViewModel()
    private let input: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private var bag = Set<AnyCancellable>()
    
    var dataSource: UITableViewDiffableDataSource<Int, ArticlePreview>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setLayout()
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { output in
                switch output {
                case .listOfRecordTapped:
                    print("d")
                }
            }.store(in: &bag)
        input.send(.viewApear)
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(rightBarButtonTapped))
        navigationItem.title = "Daily Record"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setLayout() {
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: "RecordCell")
//        dataSource = UITableViewDiffableDataSource<Int, ArticlePreview>(tableView: tableView,
//                                                                        cellProvider:
//                                                                            { tableView, indexPath, itemIdentifier in
//            
//        })
    }
}

extension HomeViewController {
    @objc private func rightBarButtonTapped() {
        print("Tapped Right bar button")
    }
}
