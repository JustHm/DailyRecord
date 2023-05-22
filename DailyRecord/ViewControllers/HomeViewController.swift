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
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ArticlePreview>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, ArticlePreview>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setLayout()
        configureDatasource()
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
    
    typealias CellRegistration = UICollectionView.CellRegistration<RecordViewCell, ArticlePreview>
    
    private func configureDatasource() {
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        
        let cellRegisteration = CellRegistration { cell, indexPath, itemIdentifier in
            cell.configure(title: itemIdentifier.title, date: itemIdentifier.date)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ArticlePreview>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
        })
        
        snapshot = NSDiffableDataSourceSnapshot<Section, ArticlePreview>()
        let sampleData = [
            ArticlePreview(title: "A", date: Date()),
            ArticlePreview(title: "B", date: Date()),
            ArticlePreview(title: "C", date: Date()),
            ArticlePreview(title: "D", date: Date()),
            ArticlePreview(title: "E", date: Date()),
            ArticlePreview(title: "F", date: Date()),
            ArticlePreview(title: "G", date: Date()),
            ArticlePreview(title: "H", date: Date()),
            ArticlePreview(title: "I", date: Date()),
            ArticlePreview(title: "J", date: Date()),
            ArticlePreview(title: "K", date: Date()),
            ArticlePreview(title: "L", date: Date()),
            ArticlePreview(title: "M", date: Date()),
            ArticlePreview(title: "N", date: Date()),
            ArticlePreview(title: "O", date: Date()),
            ArticlePreview(title: "P", date: Date()),
            ArticlePreview(title: "Q", date: Date()),
            ArticlePreview(title: "R", date: Date()),
            ArticlePreview(title: "S", date: Date()),
            ArticlePreview(title: "T", date: Date()),
            ArticlePreview(title: "U", date: Date()),
            ArticlePreview(title: "V", date: Date()),
            ArticlePreview(title: "W", date: Date()),
            ArticlePreview(title: "X", date: Date()),
            ArticlePreview(title: "Y", date: Date()),
            ArticlePreview(title: "Z", date: Date())
        ]
        snapshot.appendSections([.main])
        snapshot.appendItems(sampleData, toSection: .main)
        dataSource.apply(snapshot)
    }
    
//    private func createLayout() -> UICollectionViewLayout {
//        let sectionProvider = { /*[weak self]*/ (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
//
//            let section: NSCollectionLayoutSection
//
//            if sectionKind == .one {
//                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//
//                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28), heightDimension: .fractionalWidth(0.2))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//                section = NSCollectionLayoutSection(group: group)
//
//                section.interGroupSpacing = 10
//                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//            } else if sectionKind == .two {
//                var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//                configuration.showsSeparators = true
//                configuration.headerMode = .none
//
//                section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
//            } else {
//                fatalError("Unknown section!")
//            }
//            return section
//        }
//
//        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
//    }
}

extension HomeViewController {
    @objc private func rightBarButtonTapped() {
        print("Tapped Right bar button")
    }
}

enum Section {
    case main
}
