//
//  WiFiSettingViewController.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/12/3.
//

import UIKit

class WiFiSettingViewController: UIViewController {
    
    enum Section: CaseIterable {
        case config, networks
    }
    
    enum ItemType {
        case wifiEnabled, currentNetwork, availableNetwork
    }
    
    struct Item: Hashable {
        let title: String
        let type: ItemType
        let network: WiFiController.Network?
        
        init(title: String, type: ItemType) {
            self.title = title
            self.type = type
            self.network = nil
            self.identifier = UUID()
        }
        
        init(network: WiFiController.Network) {
            self.title = network.name
            self.type = .availableNetwork
            self.network = network
            self.identifier = network.identifier
        }
        
        var isConfig: Bool {
            let configItems: [ItemType] = [.currentNetwork, .wifiEnabled]
            return configItems.contains(type)
        }
        
        var isNetwork: Bool {
            return type == .availableNetwork
        }
        
        private let identifier: UUID
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var dataSource: UITableViewDiffableDataSource<Section, Item>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Item>! = nil
    var wifiController: WiFiController! = nil
    lazy var configurationItems: [Item] = {
        return [
            Item(title: "Wi-Fi", type: .wifiEnabled),
            Item(title: "breeno-net", type: .currentNetwork)
        ]
    }()
    
    static let reuseIdentifier = "reuse-identifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Wi-Fi"
        configureTableView()
        configureDataSource()
        updateUI(animated: true)
    }

}

extension WiFiSettingViewController {
    
    private func configureDataSource() {
        wifiController = WiFiController { [weak self] (controller: WiFiController) in
            guard let self = self else { return }
            self.updateUI()
        }
        
        self.dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) {
            [weak self] (tableView, indexPath, item: Item) -> UITableViewCell? in
            guard let self = self, let wifiController = self.wifiController else { return nil }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: WiFiSettingViewController.reuseIdentifier, for: indexPath)
            
            var content = cell.defaultContentConfiguration()
            if item.isNetwork {
                content.text = item.title
                cell.accessoryType = .detailDisclosureButton
                cell.accessoryView = nil
            } else if item.isConfig {
                content.text = item.title
                if item.type == .wifiEnabled {
                    let enableWifiSwitch = UISwitch()
                    enableWifiSwitch.isOn = wifiController.wifiEnabled
                    enableWifiSwitch.addTarget(self, action: #selector(self.toggleWifi(_:)), for: .touchUpInside)
                    cell.accessoryView = enableWifiSwitch
                } else {
                    cell.accessoryView = nil
                    cell.accessoryType = .detailDisclosureButton
                }
            } else {
                fatalError("Unknown item type!")
            }
            cell.contentConfiguration = content
            return cell
        }
        
        self.dataSource.defaultRowAnimation = .fade
        
        wifiController.scanForNetworks = true
    }
    
    private func updateUI(animated: Bool = true) {
        guard let controller = self.wifiController else { return }
        
        let configItems = configurationItems.filter { !($0.type == .currentNetwork && !controller.wifiEnabled) }
        
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        currentSnapshot.appendSections([.config])
        currentSnapshot.appendItems(configItems, toSection: .config)
        
        if controller.wifiEnabled {
            let sortedNetworks = controller.availableNetworks.sorted { $0.name < $1.name }
            let networkItems = sortedNetworks.map { Item(network: $0) }
            currentSnapshot.appendSections([.networks])
            currentSnapshot.appendItems(networkItems, toSection: .networks)
        }
        
        self.dataSource.apply(currentSnapshot, animatingDifferences: animated)
    }
    
}

extension WiFiSettingViewController {
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: WiFiSettingViewController.reuseIdentifier)
    }
    
    @objc
    private func toggleWifi(_ wifiEnabledSwitch: UISwitch) {
        wifiController.wifiEnabled = wifiEnabledSwitch.isOn
        updateUI()
    }
    
}
