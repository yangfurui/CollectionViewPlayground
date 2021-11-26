//
//  Colletion_DragAndDropModel.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/25.
//

import UIKit

class Colletion_DragAndDropModel: NSObject, NSItemProviderWriting {
    
    var content: String
    var cellBackgroundColor: UIColor
    
    init(content: String, cellBackgroundColor: UIColor) {
        self.content = content
        self.cellBackgroundColor = cellBackgroundColor
    }
    
    // MARK: - NSItemProviderWriting
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        return ["collection_drag_drop"]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil
    }
}
