//
//  FacialEmojiCell.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/30.
//

import UIKit

class FacialEmojiCell: UICollectionViewCell {
    let imageBackgroundView = UIView()
    let imageView = UIImageView()
    let label = UILabel()
    static let reuseIdentifier = "FacialEmojiCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FacialEmojiCell {
    private func configure() {
        
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundView.backgroundColor = .black.withAlphaComponent(0.1)
        imageBackgroundView.layer.cornerRadius = 10
        contentView.addSubview(imageBackgroundView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .systemFont(ofSize: 11)
        label.textColor = .white
        label.textAlignment = .center
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageBackgroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageBackgroundView.bottomAnchor.constraint(equalTo: label.topAnchor)
        ])
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: imageBackgroundView.leadingAnchor, constant: inset),
            imageView.trailingAnchor.constraint(equalTo: imageBackgroundView.trailingAnchor, constant: -inset),
            imageView.topAnchor.constraint(equalTo: imageBackgroundView.topAnchor, constant: inset),
            imageView.bottomAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor, constant: -inset)
        ])
        
        let labelInset = CGFloat(5)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leftAnchor.constraint(equalTo: imageBackgroundView.leftAnchor, constant: labelInset),
            label.rightAnchor.constraint(equalTo: imageBackgroundView.rightAnchor, constant: -labelInset)
        ])
    }
}
