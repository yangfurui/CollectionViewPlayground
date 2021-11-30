//
//  SectionBackgroundDecorationView.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/30.
//

import UIKit

class SectionBackgroundDecorationView: UICollectionReusableView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
}

extension SectionBackgroundDecorationView {
    private func configure() {
        backgroundColor = .lightGray.withAlphaComponent(0.5)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
    }
}
