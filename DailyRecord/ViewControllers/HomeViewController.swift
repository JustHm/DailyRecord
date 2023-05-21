//
//  HomeViewController.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/15.
//

import UIKit
import SwiftUI
import Combine

class HomeViewController: UIViewController {
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = HomeViewModel()
    private let input: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private var bag = Set<AnyCancellable>()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, ArticlePreview>!
    var snapshot: NSDiffableDataSourceSnapshot<Int, ArticlePreview>!
    
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
                case .setCellData:
                    break
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
        guard let view = UIHostingController(rootView: InfoView()).view else { return }
        
        infoView.layer.cornerRadius = 12.0
        infoView.clipsToBounds = true
        
        infoView.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.topAnchor.constraint(equalTo: infoView.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: infoView.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: infoView.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: infoView.bottomAnchor).isActive = true
    }
}

extension HomeViewController {
    @objc private func rightBarButtonTapped() {
        print("Tapped Right bar button")
    }
}
