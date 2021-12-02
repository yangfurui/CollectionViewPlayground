//
//  NewSSEmojiContainerViewController.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/30.
//

import UIKit

class NewSSEmojiContainerViewController: UIViewController {
    
    private enum Section {
        case main
    }
    
    private struct ItemModel: Hashable {
        
        var id: Int
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        private var identifier: Int { id }
    }
    
    private static let sectionHeaderElementKind = "emoji-container-section-header-element-kind"
    
    private var itemModels = [ItemModel]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemModel>! = nil
    private var collectionView: UICollectionView! = nil
    // 在有header的情况下，按住header拖动，会导致监听滚动的方法不断回调，这里记录一下lastPost以避免didScrollTo方法调用的太频繁
    private var lastPoint: CGPoint = .zero
    private var containerView: UIView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        navigationItem.title = "Newss Emoji"
        configureHierarchy()
        configureDataSource()
        
        func setupNavigationItem() {
            navigationItem.title = "Drag And Drop Demo"
            let showItem = UIBarButtonItem(title: "show", style: .plain, target: self, action: #selector(_showItemClick(_:)))
            navigationItem.rightBarButtonItem = showItem
        }
        
        setupNavigationItem()
    }
}

extension NewSSEmojiContainerViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(312))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let orthogonallyScrolls = UICollectionLayoutSectionOrthogonalScrollingBehavior.paging
        section.orthogonalScrollingBehavior = orthogonallyScrolls
        
        // 滚动监听
        section.visibleItemsInvalidationHandler = { (visibleItems, point, environment) in
            let onePageOffset = self.collectionView.bounds.size.width
            for (idx, _) in self.itemModels.enumerated() {
                guard CGFloat(idx) * onePageOffset == point.x, self.lastPoint.x != point.x else { continue }
                self.lastPoint = point
                self.didScrollTo(idx)
            }
        }
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: NewSSEmojiContainerViewController.sectionHeaderElementKind,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        sectionHeader.pinToVisibleBounds = true

        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = config
        
        return layout
    }
    
    private func configureHierarchy() {
        
        containerView = UIView()
        containerView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: CGFloat(360))
        containerView.backgroundColor = .green
        view.addSubview(containerView)
        
        let collectionViewFrame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: CGFloat(360))
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .purple
        collectionView.alwaysBounceVertical = false
        collectionView.delegate = self
        containerView.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CS_FacialContainerItemCell, Int> { (cell, indexPath, identifier) in
            cell.contentView.backgroundColor = .random
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <CS_EmojiSupplementaryView>(elementKind: NewSSEmojiContainerViewController.sectionHeaderElementKind) {
            (supplementaryView, string, indexPath) in
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ItemModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: ItemModel) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item.id)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            if kind == NewSSEmojiContainerViewController.sectionHeaderElementKind {
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
            }
            return nil
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemModel>()
        snapshot.appendSections([.main])
        (0..<3).forEach {
            self.itemModels.append(ItemModel(id: $0))
        }
        snapshot.appendItems(itemModels, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func didScrollTo(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        // 选中header
        if let header = collectionView.supplementaryView(forElementKind: NewSSEmojiContainerViewController.sectionHeaderElementKind, at: indexPath) as? TitleSupplementaryView {
            
        }
        print("did scroll to \(index)")
    }
    
    // MARK: - Actions
    
    @objc private func _showItemClick(_ sender: UIBarButtonItem) {
        let collectionViewH = CGFloat(360)
        containerView.frame.size.height = collectionViewH + view.safeAreaInsets.bottom
        collectionView.frame.size.height = collectionViewH
        let diff = containerView.frame.origin.y == view.bounds.height ? containerView.bounds.height : 0
        UIView.animate(withDuration: 0.3) {
            self.containerView.frame.origin.y = self.view.bounds.height - diff
        }
    }
}

extension NewSSEmojiContainerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
