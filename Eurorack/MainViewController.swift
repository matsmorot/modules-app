//
//  MainViewController.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-07-28.
//

import UIKit
import Combine
import SwiftUI

class MainViewController: UIViewController {
        
    let moduleService: ModuleService = ModuleService()
    
    var dataSource: UICollectionViewDiffableDataSource<Section.ID, Module.ID>!
    var collectionView: UICollectionView!
    var delegate: UICollectionViewDelegate!
        
    fileprivate var prefetchingIndexPathOperations = [IndexPath: Task<Void, Never>]()
        
    var modules: [Module] = []
    
    init() {
        super.init(nibName: nil, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            self.modules = try await moduleService.getModules()
            setInitialData()
        }
                        
        title = "Eurorack Modules"
        configureView()
        configureDataSource()
    }
    
    private func configureView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configureCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [CGColor(red: 0.55, green: 0.25, blue: 0.35, alpha: 1), CGColor(red: 0.45, green: 0.15, blue: 0.25, alpha: 1)]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    private func configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(360))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Module.ID> { cell, indexPath, moduleID in
                cell.contentConfiguration = UIHostingConfiguration {
                    CustomSwiftUICellView(moduleID: moduleID)
                        .frame(maxWidth: .infinity, maxHeight: 360)
                        .background(Color.sand)
                        .clipShape(.rect(cornerRadius: 10))
                }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section.ID, Module.ID>(collectionView: collectionView) { (collectionView, indexPath, moduleID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: moduleID)
        }
    }
    
    private func setModuleNeedsUpdate(_ id: Module.ID) {
            var snapshot = self.dataSource.snapshot()
            snapshot.reconfigureItems([id])
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    
    private func setInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section.ID, Module.ID>()
        snapshot.appendSections(Section.ID.allCases)
        
        let itemIdentifiers = modules.map { $0.id }
        snapshot.appendItems(itemIdentifiers)
        print("DEBUG: \(itemIdentifiers)")
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let moduleID = self.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let viewModel = ModuleViewModel(id: moduleID)
        let moduleView = ModuleView(viewModel: viewModel)
        let moduleViewHostingController = UIHostingController(rootView: moduleView)
        
        self.navigationController?.pushViewController(moduleViewHostingController, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
                guard prefetchingIndexPathOperations[indexPath] == nil else { continue }
                guard let moduleID = self.dataSource.itemIdentifier(for: indexPath) else { continue }
                
                let task = Task { [weak self] in
                    defer { self?.prefetchingIndexPathOperations[indexPath] = nil }
                    do {
                        let module = try await self?.moduleService.getModule(moduleID: moduleID)
                        print("DEBUG: Prefetching \(String(describing: module?.name))")
                        await MainActor.run {
                            self?.setModuleNeedsUpdate(moduleID)
                        }
                    } catch {
                        print("ERROR DEBUG: Could not download module")
                    }
                }
                prefetchingIndexPathOperations[indexPath] = task
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            prefetchingIndexPathOperations.removeValue(forKey: indexPath)?.cancel()
        }
    }
}
