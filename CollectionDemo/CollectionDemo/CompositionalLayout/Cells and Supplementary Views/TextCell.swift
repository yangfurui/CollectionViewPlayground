//
//  TextCell.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/29.
//

import UIKit

class TextCell: UICollectionViewCell {
    
    let label = UILabel()
    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
}

extension TextCell {
    func configure() {
        // 允许给label添加额外的约束
        label.translatesAutoresizingMaskIntoConstraints = false
        // label随系统字体调整而调整
        label.adjustsFontForContentSizeCategory = true
        contentView.addSubview(label)
        label.font = .preferredFont(forTextStyle: .caption1)
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
}


class TestCell: UICollectionViewCell {
    static let reuseIdentifier = "text-cell-reuse-identifier"
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
}
