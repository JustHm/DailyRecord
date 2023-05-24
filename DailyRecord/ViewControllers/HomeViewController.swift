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
                case .listFilter(let date):
                    self?.setFilterLabel(date: date)
                case .showAlert(_):
                    break
                }
            }.store(in: &bag)
        input.send(.viewApear)
    }
    private func setFilterLabel(date: String) {
        filterLabel.text = date
    }
    
    private func setDatasource(data: [ArticlePreview]) {
        snapshot = NSDiffableDataSourceSnapshot<Section, ArticlePreview>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    @IBAction func addDiaryButtonTapped(_ sender: UIButton) {
        //EX) 2023.05.01
        if let lastDate = UserDefaults.standard.string(forKey: "LastAddDate") {
            //마지막으로 추가한 날짜가 있다면 현재 날짜와 비교, 오늘 했다면 return
            if Date().toString() == lastDate { return }
        }
        //여기에서 add화면으로 이동
        UserDefaults.standard.set(Date().toString(), forKey: "LastAddDate")
    }
    
    @IBAction func filterRightButtonTapped(_ sender: UIButton) {
        input.send(.nextFilter)
    }
    
    @IBAction func filterLeftButtonTapped(_ sender: UIButton) {
        input.send(.prevFilter)
    }
    
    @objc private func rightBarButtonTapped() {
        //show App settings view
        
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        let detailView = UIHostingController(rootView: DetailView(article: Article(imagesURL: [], text: "a;lskdfjalsjdkljasl;dfjak;lsdjfk\nasldk;fjakl;sdjf;lajs;dfl", date: Date().toString(), weather: "sun.max.fill")))
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
