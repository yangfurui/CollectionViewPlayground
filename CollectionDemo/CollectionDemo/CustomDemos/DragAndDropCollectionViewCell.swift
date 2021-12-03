//
//  DragAndDropCollectionViewCell.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/25.
//

import UIKit

class DragAndDropCollectionViewCell: UICollectionViewCell {
    
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
