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
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = HomeViewModel()
    private let input: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private var bag = Set<AnyCancellable>()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ArticlePreview>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, ArticlePreview>!
    typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ArticlePreview>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        configureDatasource()
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .setCellData(let data):
                    self?.setDatasource(data: data)
                }
            }.store(in: &bag)
        input.send(.viewApear)
    }
    
    private func setDatasource(data: [ArticlePreview]) {
        snapshot = NSDiffableDataSourceSnapshot<Section, ArticlePreview>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    @IBAction func addDiaryButtonTapped(_ sender: UIButton) {
        
    }
    @IBAction func filterRightButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func filterLeftButtonTapped(_ sender: UIButton) {
    }
    @objc private func rightBarButtonTapped() {
        print("Tapped Right bar button")
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        let detailView = UIHostingController(rootView: DetailView(article: Article(imagesURL: [], descibe: "a;lskdfjalsjdkljasl;dfjak;lsdjfk\nasldk;fjakl;sdjf;lajs;dfl", date: Date(), weather: "sun.max.fill")))
        show(detailView, sender: nil)
    }
}

extension HomeViewController {
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(rightBarButtonTapped)
        )
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        var separator = UIListSeparatorConfiguration(listAppearance: .plain)
        
        separator.color = .white
        config.backgroundColor = .clear
        config.separatorConfiguration = separator
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureDatasource() {
        collectionView.collectionViewLayout = createListLayout()
        collectionView.delegate = self
        
        let cellRegisteration = CellRegistration { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            var background = UIBackgroundConfiguration.listPlainCell()
            
            configuration.image = UIImage(systemName: itemIdentifier.weather)?.withRenderingMode(.alwaysOriginal)
            configuration.text = itemIdentifier.date.formatted(.iso8601)
            configuration.textProperties.color = .white
            
            background.backgroundColor = .clear
            
            cell.accessories = [.disclosureIndicator()]
            cell.backgroundConfiguration = background
            cell.contentConfiguration = configuration
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ArticlePreview>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
        })
    }
}

enum Section {
    case main
}
