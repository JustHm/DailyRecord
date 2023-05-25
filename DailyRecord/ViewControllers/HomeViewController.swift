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
    @IBOutlet weak var sortButton: UIButton!
    
    private let viewModel = HomeViewModel()
    private let input: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private var bag = Set<AnyCancellable>()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Article>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, Article>!
    typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Article>
    
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
                case .showAlert(let msg):
                    self?.showAlert(msg: msg)
                case .sortState(let descending):
                    var sfSymbolName = ""
                    if descending { sfSymbolName = "chevron.up.square"}
                    else { sfSymbolName = "chevron.down.square" }
                    self?.sortButton.setImage(UIImage(systemName: sfSymbolName), for: .normal)
                }
            }.store(in: &bag)
        input.send(.viewApear)
    }
    private func setFilterLabel(date: String) {
        filterLabel.text = date
    }
    
    private func setDatasource(data: [Article]) {
        snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    @IBAction func addDiaryButtonTapped(_ sender: UIButton) {
        if let lastDate = UserDefaults.standard.string(forKey: "LastAddDate") {
            if Date().toString() == lastDate {
                showAlert(msg: "이미 오늘의 기록을 완료했습니다.")
                return
            }
        }
        let vc = UIHostingController(rootView: AddView(input: input))
        show(vc, sender: nil)
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        input.send(.sortFilter)
    }
    
    @IBAction func filterRightButtonTapped(_ sender: UIButton) {
        input.send(.nextFilter)
    }
    
    @IBAction func filterLeftButtonTapped(_ sender: UIButton) {
        input.send(.prevFilter)
    }
    
    @objc private func rightBarButtonTapped() {
        //show App settings view
        let vc = UIHostingController(rootView: SettingsView())
        show(vc, sender: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailView = UIHostingController(rootView: DetailView(article: item))
        show(detailView, sender: nil)
    }
}

extension HomeViewController {
    
    private func showAlert(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        present(alert, animated: true, completion: { self.dismiss(animated: true)})
    }
    
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
            configuration.text = "\(itemIdentifier.date)의 기록"
            configuration.textProperties.color = .white
            
            background.backgroundColor = .clear
            
            cell.accessories = [.disclosureIndicator()]
            cell.backgroundConfiguration = background
            cell.contentConfiguration = configuration
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Article>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
        })
    }
}

enum Section {
    case main
}
