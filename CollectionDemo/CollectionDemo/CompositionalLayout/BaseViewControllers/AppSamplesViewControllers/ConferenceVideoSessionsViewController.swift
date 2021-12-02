//
//  ConferenceVideoSessionsViewController.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/12/2.
//

import UIKit

class ConferenceVideoSessionsViewController: UIViewController {
    
    let videosController = ConferenceVideoController()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>! = nil
    static let titleElementKind = "title-element-kind"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Conference Videos"
        configureHierarchy()
        configureDataSource()
    }

}

extension ConferenceVideoSessionsViewController {
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIdex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ? 0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: ConferenceVideoSessionsViewController.titleElementKind,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}

extension ConferenceVideoSessionsViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ConferenceVideoCell, ConferenceVideoController.Video> {
            (cell, indexPath, video) in
            cell.titleLabel.text = video.title
            cell.categoryLabel.text = video.category
        }
        
        dataSource = UICollectionViewDiffableDataSource<ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>(collectionView: collectionView) {
            (collectionView, indexPath, video: ConferenceVideoController.Video) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: video)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: ConferenceVideoSessionsViewController.titleElementKind) {
            (supplementaryView, elementKind, indexPath) in
            if let snapshot = self.currentSnapshot {
                let videoCategory = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = videoCategory.title
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
        }
        
        currentSnapshot = NSDiffableDataSourceSnapshot<ConferenceVideoController.VideoCollection, ConferenceVideoController.Video>()
        videosController.colletions.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.videos)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}
