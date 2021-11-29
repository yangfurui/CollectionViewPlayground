//
//  DragAndDropViewModel.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/25.
//

import UIKit

class DragAndDropViewModel {
    private(set) var dataSource: [DragAndDropModel]
    
    init() {
        dataSource = DragAndDropViewModel.prepareDataSource()
    }
    
    func removeObjectFromDataSource(at index: Int) {
        guard index >= 0, index < dataSource.count else { return }
        dataSource = dataSource.filter { $0 != dataSource[index] }
    }
    
    func insertObjectToDataSource(_ newElement: DragAndDropModel, at index: Int) {
        guard index >= 0 else { return }
        dataSource.insert(newElement, at: index)
    }
    
    func reset(complete: (()->Void)? = nil) {
        dataSource = DragAndDropViewModel.prepareDataSource()
        complete?()
    }
    
    static func prepareDataSource() -> [DragAndDropModel] {
        var result = [DragAndDropModel]()
        for i in 0..<100 {
            result.append(DragAndDropModel(content: String(i), cellBackgroundColor: .random))
        }
        return result
    }
    
}
