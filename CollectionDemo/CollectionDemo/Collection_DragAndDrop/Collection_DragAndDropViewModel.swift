//
//  Collection_DragAndDropViewModel.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/25.
//

import UIKit

class Collection_DragAndDropViewModel {
    private(set) var dataSource: [Colletion_DragAndDropModel]
    
    init() {
        dataSource = Collection_DragAndDropViewModel.prepareDataSource()
    }
    
    func removeObjectFromDataSource(at index: Int) {
        guard index >= 0, index < dataSource.count else { return }
        dataSource = dataSource.filter { $0 != dataSource[index] }
    }
    
    func insertObjectToDataSource(_ newElement: Colletion_DragAndDropModel, at index: Int) {
        guard index >= 0 else { return }
        dataSource.insert(newElement, at: index)
    }
    
    func reset(complete: (()->Void)? = nil) {
        dataSource = Collection_DragAndDropViewModel.prepareDataSource()
        complete?()
    }
    
    static func prepareDataSource() -> [Colletion_DragAndDropModel] {
        var result = [Colletion_DragAndDropModel]()
        for i in 0..<100 {
            result.append(Colletion_DragAndDropModel(content: String(i), cellBackgroundColor: .random))
        }
        return result
    }
    
}
