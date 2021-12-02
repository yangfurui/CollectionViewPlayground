//
//  ConferenceNewsFeedViewController.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/12/2.
//

import UIKit

class ConferenceNewsFeedViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ConferenceNewsController.NewsFeedItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Conference News Feed"
        configureHierarchy()
        configureDataSource()
    }

}

extension ConferenceNewsFeedViewController {
    func createLayout() -> UICollectionViewLayout {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
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
        let newController = ConferenceNewsController()
        
        let cellRegistration = UICollectionView.CellRegistration<ConferenceNewsFeedCell, ConferenceNewsController.NewsFeedItem> {
            (cell, indexPath, newsItem) in
            cell.titleLabel.text = newsItem.title
            cell.bodyLabel.text = newsItem.body
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            cell.dateLabel.text = dateFormatter.string(from: newsItem.date)
            cell.showsSeparator = indexPath.item != newController.items.count - 1
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ConferenceNewsController.NewsFeedItem>(collectionView: collectionView) {
            (collectionView, indexPath, newsItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: newsItem)
        }
        
        // load out data
        let newsItems = newController.items
        var snapshot = NSDiffableDataSourceSnapshot<Section, ConferenceNewsController.NewsFeedItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(newsItems)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
