//
//  ViewController.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private var _viewModel: CollectionViewModel = CollectionViewModel()
    private lazy var _collectionView: UICollectionView = _getCollectionView()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "CollectionView Demos"
        
        view.addSubview(_collectionView)
        _collectionView.frame = view.bounds
    }
    
    // MARK: - Public
    
    @objc private func refreshControlDidFire(_ sender: UIRefreshControl) {
        
    }
    
    // MARK: - Privates

    private func _getCollectionView() -> UICollectionView {
        
        func getFlowLayout() -> UICollectionViewFlowLayout {
            let layout = UICollectionViewFlowLayout()
            let marginForRow: CGFloat = 10
            let collectionViewRow = 1
            let collectionViewItemHeight: CGFloat = view.bounds.height / 12
            let collectionViewItemWidth = (view.bounds.width - CGFloat(collectionViewRow+1) * marginForRow) / CGFloat(collectionViewRow)
            layout.itemSize = CGSize(width: collectionViewItemWidth, height: collectionViewItemHeight)
            layout.minimumLineSpacing = marginForRow
            layout.minimumInteritemSpacing = marginForRow
            layout.scrollDirection = .vertical
            return layout
        }
        
        let flowLayout = getFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: flowLayout.minimumInteritemSpacing, bottom: 0, right: flowLayout.minimumInteritemSpacing)
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        return collectionView
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _viewModel.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.titleLabel.text = _viewModel.dataSource[indexPath.item].conetnt
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch _viewModel.dataSource[indexPath.item].demoType {
        case .dragAndDrop:
            navigationController?.pushViewController(Colletion_DragAndDropViewController(), animated: true)
        default:
            break
        }
    }
    
}

struct CollectionViewModel {
    private(set) var dataSource: [CollectionModel]
    
    init() {
        dataSource = CollectionViewModel.prepareDataSource()
    }
    
    static func prepareDataSource() -> [CollectionModel] {
        var result = [CollectionModel]()
        
        result.append(CollectionModel(demoType: .dragAndDrop))
        
        return result
    }
}

struct CollectionModel {
    enum Demo_Type: String {
        case none = ""
        case dragAndDrop = "Drag and Drop"
    }

    var demoType: Demo_Type
    var conetnt: String { demoType.rawValue }
}

class CustomCollectionViewCell: UICollectionViewCell {
    
    private(set) lazy var titleLabel: UILabel = _getTitleLabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Privates
    
    private func _initUI() {
        contentView.backgroundColor = .systemBlue
        contentView.layer.cornerRadius = 10
        contentView.addSubview(titleLabel)
        titleLabel.frame = bounds
    }
    
    private func _getTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        return label
    }
    
}
