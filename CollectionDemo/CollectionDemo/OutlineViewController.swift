//
//  OutlineViewController.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/29.
//

import UIKit

class OutlineViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    class OutlineItem: Hashable {
        let title: String
        let subitems: [OutlineItem]
        let outlineViewController: UIViewController.Type?
        
        init(title: String, viewController: UIViewController.Type? = nil, subitems: [OutlineItem] = []) {
            self.title = title
            self.outlineViewController = viewController
            self.subitems = subitems
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        private let identifier = UUID()
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>! = nil
    var outlineCollectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Collection View Demos"
        configureCollectionView()
        configDataSource()
    }
    
    private lazy var menuItems: [OutlineItem] = {
        return [
//            OutlineItem(title: "New Emoji", viewController: NewSSEmojiContainerViewController.self),
            OutlineItem(title: "Drag And Drop", viewController: DragAndDropViewController.self),
            OutlineItem(title: "Compositional Layout", subitems: [
                OutlineItem(title: "Getting Started", subitems: [
                    OutlineItem(title: "Grid", viewController: GridViewController.self),
                    OutlineItem(title: "Two-Column Grid", viewController: TwoColumnViewController.self),
                    OutlineItem(title: "Per-Section Layout", subitems: [
                        OutlineItem(title: "Distinct Sections", viewController: DistinctSectionsViewController.self)
                    ])
                ]),
                OutlineItem(title: "Advanced Layouts", subitems: [
                    OutlineItem(title: "Supplementary Views", subitems: [
                        OutlineItem(title: "Pinned Section Headers/Footers", viewController: PinnedSectionHeaderFooterViewController.self)
                    ]),
                    OutlineItem(title: "Section Background Decoration", viewController: SectionDecorationViewController.self)
                ]),
                OutlineItem(title: "Orthogonal Sections", subitems: [
                    OutlineItem(title: "Orthogonal Section Behaviors")
                ])
            ])
        ]
    }()

}

private extension OutlineViewController {
        
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemGroupedBackground
        self.outlineCollectionView = collectionView
        collectionView.delegate = self
    }
    
    func configDataSource() {
        // 填充 cell 的内容
        let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { (cell, indexPath, menuItem) in
            // Populate the cell with our item description.
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration
            
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { (cell, indexPath, menuItem) in
            // Populate the cell with our item description.
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, OutlineItem>(collectionView: outlineCollectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, item: OutlineItem) -> UICollectionViewCell? in
            // Return the cell
            if item.subitems.isEmpty {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: item)
            }
        })
        
        // load our initial data
        let snapshot = initialSnapshot()
        dataSource.apply(snapshot, to: .main, animatingDifferences: false)
        
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
    
    func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<OutlineItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>()
        
        func addItems(_ menuItems: [OutlineItem], to parent: OutlineItem?) {
            snapshot.append(menuItems, to: parent)
            for menuItem in menuItems where !menuItem.subitems.isEmpty {
                addItems(menuItem.subitems, to: menuItem)
            }
        }
        
        addItems(menuItems, to: nil)
        return snapshot
    }
    
}

extension OutlineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        if let viewController = menuItem.outlineViewController {
            navigationController?.pushViewController(viewController.init(), animated: true)
        }
    }
}
