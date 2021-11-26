//
//  DragAndDropViewController.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/25.
//

import UIKit

class Colletion_DragAndDropViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = Collection_DragAndDropViewModel()
    private let collectionCellIdentifier = "Collection_DragAndDropCollectionViewCell"
    private lazy var flowLayout: UICollectionViewFlowLayout = _getCollectionViewLayout()
    private lazy var collectionView: UICollectionView = _getCollectionView()
    private var dragIndexPath: IndexPath?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        func setupNavigationItem() {
            navigationItem.title = "Drag And Drop Demo"
            let resetItem = UIBarButtonItem(title: "reset", style: .plain, target: self, action: #selector(_resetItemClick(_:)))
            navigationItem.rightBarButtonItem = resetItem
        }
        
        setupNavigationItem()

        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    // MARK: - Privates
    
    @objc private func _resetItemClick(_ sender: UIBarButtonItem) {
        viewModel.reset { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func _getCollectionView() -> UICollectionView {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.register(Collection_DragAndDropCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        // ipad默认为true，iphone默认为false
        collectionView.dragInteractionEnabled = true
        // immediate: 默认值，开始移动时立即回流布局，可以理解为实时的重新布局
        // fast: 快速移动时，CollectionView 不会立即重新布局，只有在停止移动的时候才会重新布局
        // slow: 停止移动再过一会儿才会开始回流，重新布局
        collectionView.reorderingCadence = .immediate
        collectionView.isSpringLoaded = true
        return collectionView
    }
    
    private func _getCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let marginForRow: CGFloat = 10
        let collectionViewRow = 4
        let collectionViewItemHeight: CGFloat = 100
        let collectionViewItemWidth = (UIScreen.main.bounds.size.width - CGFloat(collectionViewRow+1) * marginForRow) / CGFloat(collectionViewRow)
        layout.itemSize = CGSize(width: collectionViewItemWidth, height: collectionViewItemHeight)
        layout.minimumLineSpacing = marginForRow
        layout.minimumInteritemSpacing = marginForRow
        layout.scrollDirection = .vertical
        return layout
    }

}

extension Colletion_DragAndDropViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! Collection_DragAndDropCollectionViewCell
        cell.titleLabel.text = viewModel.dataSource[indexPath.item].content
        cell.contentView.backgroundColor = viewModel.dataSource[indexPath.item].cellBackgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return collectionView.dragInteractionEnabled
    }
}

extension Colletion_DragAndDropViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    // MARK: - Drag
    
    // 提供一个给定 indexPath 的可进行 drag 操作的 item 数组
    // 如果返回空数组，拖拽不会执行
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: viewModel.dataSource[indexPath.item])
        let item = UIDragItem(itemProvider: itemProvider)
        dragIndexPath = indexPath
        return [item]
    }
    
    // 可以选中多个 item，选中一个item，用另外一个手指选中其他 item，未实现或返回空，则不会添加额外的item到正在拖动的 items 中，但是手势会正常响应
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: viewModel.dataSource[indexPath.item])
        let item = UIDragItem(itemProvider: itemProvider)
        return [item]
    }
    
    // 可以自定义拖拽时的预览，如果没有实现或者返回 nil，那么将使用整个 cell 作为预览
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        // UIDragPreviewParameters - visblePath
        // 设置可见区域，传入nil则使用整个视图
        
        // UIDragPreviewParameters - shadowPath
        // 用于设置预览的阴影，是贝塞尔曲线，如果为 nil 则使用 visblePath
        
        let parameters = UIDragPreviewParameters()
        let rect = CGRect(x: 0, y: 0, width: flowLayout.itemSize.width, height: flowLayout.itemSize.height)
        parameters.visiblePath = UIBezierPath(roundedRect: rect, cornerRadius: .zero)
        // 去掉拖拽视图的阴影
        parameters.shadowPath = UIBezierPath(roundedRect: .zero, cornerRadius: .zero)
        parameters.backgroundColor = .clear
        return parameters
    }
    
    // 当选中某一个item的动画完成之后，开始拖拽之前会调用该方法
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        print("dragSessionWillBegin")
    }
    
    // 拖拽结束的时候会调用该方法
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        print("dragSessionDidEnd")
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return true
    }
    
    // 能不能被拖动到另外的app，默认为 false
    func collectionView(_ collectionView: UICollectionView, dragSessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
        return false
    }
    
    // MARK: - Drop
    
    // 用户发起 drop 时调用
    // 使用 dropCoordinator 指定你想怎么样将 dropSession 的项目移动到最终位置的动画
    // 更新 collectionView 的数据源以及从数据检索中删除项目
    // 如果方法中什么也不做，会提供默认方案
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        // 只有在这个方法中才可以请求到数据
        // 请求的方式是异步的，因此不要阻止数据的传输，如果阻止时间过长，就不清楚数据要多久才能到达，系统甚至可能会kill掉你的应用
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        guard let dragItem = coordinator.items.first?.dragItem else { return }
        guard let dragIndexPath = self.dragIndexPath else { return }
        let destinationItem = viewModel.dataSource[dragIndexPath.item]
        
        // 更新collectionView
        collectionView.performBatchUpdates {
            // 目标 cell 换位置
            self.viewModel.removeObjectFromDataSource(at: dragIndexPath.item)
            self.viewModel.insertObjectToDataSource(destinationItem, at: destinationIndexPath.item)
            
            collectionView.moveItem(at: dragIndexPath, to: destinationIndexPath)
        } completion: { _ in
            
        }
        
        coordinator.drop(dragItem, toItemAt: destinationIndexPath)
    }
    
    // 提供 drop 时的方案，虽然是 optional，但是最好实现
    // 当跟踪 drop 行为时会频繁调用，因此要尽量减少这个方法的工作量
    // 当 drop 手势在 section 末端时，传递的目标索引路径还不存在（此时 indexPath 等于该 section 的行数，这时候会追加到该 section 的末尾）
    // 在某些情况下，目标索引路径可能为空（比如拖到一个没有 cell 的空白区域）
    // 某些情况下，你的方案可能不被系统允许，此时系统会执行自己的方案
    // 可以通过 UIDropSession.locationInView 执行你自己的 hit test
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        // UICollectionViewDropProposal.Indent
        // unspecified: 不会打开缺口，目标索引也不会高亮
        // insertAtDestinationIndexPath: 打开一个缺口，模拟最终释放时的效果
        // insertIntoDestinationIndexPath: 不会打开缺口，但是目标索引会高亮
        
        // 如果是另外一个 app，localDragSession 为 nil，此时可以执行 copy（当然也可以用move），通过这个属性判断是否在当前 app 中释放，当然只有 ipad 才需要这个适配
        if session.localDragSession == nil {
            return UICollectionViewDropProposal(operation: .copy, intent: .unspecified)
        }
        else {
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    // 对应 item 能否被 drop
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.localDragSession != nil
    }
    
    // 自定义 drop 的预览图
    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        // 不实现或者传 nil，会使用整个 cell 作为预览图
        // 该方法会由 UICollectionViewDropCoordinator.dropItem:toItemAtIndexPath: 调用
        // 如果要自定义占位 drop，可以查看 UICollectionViewDropPlaceholder.previewParametersProvider
        return nil
    }
    
    // 当 drop session 进入到 collectionView 的坐标区域内就会调用
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
        
        // 调用顺序
        // dragSessionWillBegin
        // dropSessionDidEnter
        // dragSessionDidEnd
        // dropSessionDidEnd
        
        print("dropSessionDidEnter")
    }
    
    // 当 drop session 不在 collectionView 的坐标区域时会被调用
    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {
        print("dropSessionDidExit")
    }
    
    // drop 完成时调用，适合做一些清理工作
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        print("dropSessionDidEnd")
    }
}
