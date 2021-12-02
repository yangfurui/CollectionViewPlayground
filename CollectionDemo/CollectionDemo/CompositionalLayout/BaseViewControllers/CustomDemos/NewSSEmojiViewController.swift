//
//  NewSSEmojiViewController.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/30.
//

import UIKit

class NewSSEmojiViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private enum SectionKind: Int, CaseIterable {
        case unityTemplate, unityAction, emoji
        var columnCount: Int {
            switch self {
            case .unityTemplate:
                return 4
            case .unityAction:
                return 4
            case .emoji:
                return 4
            }
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        navigationItem.title = "Newss Emoji"
        configureHierarchy()
        configureDataSource()
    }

}

extension NewSSEmojiViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7.5, bottom: 0, trailing: 7.5)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 7.5, leading: 0, bottom: 7.5, trailing: 0)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureHierarchy() {
        let collectionViewFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 360)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .purple
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<FacialEmojiCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.imageView.backgroundColor = .white
            cell.label.text = "\(identifier)"
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<20))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension NewSSEmojiViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

func kScale(_ value: CGFloat) -> CGFloat {
    return value*UIScreen.main.bounds.width / 375
}

func fixScale(_ value: CGFloat) -> CGFloat {
    return ceil(kScale(value))
}
