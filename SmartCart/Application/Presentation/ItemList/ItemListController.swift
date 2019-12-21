//
//  ItemListController.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit
import SnapKit

class ItemListController: UIViewController {
    
    // MARK: - Properties
    
    private var items = [Item]() {
        didSet  { contentView.tableView.reloadSections(IndexSet(integer: 0), with: .fade) }
    }
    
    private let contentView = ItemListView()
    private let presenter: ItemListPresenter
    
    // MARK: - Initialization
    
    internal init(presenter: ItemListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem?.isEnabled = false
        presenter.load()
    }
}

//MARK: - ItemListDelegate
extension ItemListController: ItemListDelegate {
    func didLoadItems(_ items: [Item]) {
        guard !items.isEmpty else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            contentView.isTableHidden = true
            logger.logInfo(message: "Successfully fetched but loaded empty array.")
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        contentView.totalPrice = calculateTotalPrice(forItems: items)
        contentView.isTableHidden = false
        self.items = items
    }
    
    func presentController(_ controller: UIViewController) {
        controller.modalPresentationStyle = .overFullScreen
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func showController(_ controller: UIViewController) {
        navigationController?.show(controller, sender: nil)
    }
    
    func removingItemDelegate(_ item: Item) {
        deleteConfirmation(forItem: item)
    }
}

// MARK: - ScannerViewDelegate
extension ItemListController: ScannerViewDelegate {
    func didScanItem(_ item: ItemEntity) {
        presenter.presentScannedItem(item, forController: self)
    }
}

extension ItemListController: AddItemDelegate {
    func willDisplayItemList() {
        presenter.load()
    }
}

// MARK: - ItemListViewDelegate
extension ItemListController: ItemListViewDelegate {
    func buttonDidTap(_ sender: UIButton) {
        guard let tag = CartItemButtonsTag(rawValue: sender.tag) else { return }
        
        switch tag {
        case .addManually:
            presenter.presentManualAdd()
        case .scan:
            presenter.presentScanner(forController: self)
        }
    }
}

// MARK: - ItemCellDelegate
extension ItemListController: ItemCellDelegate {
    func controlButtonDidTap(_ sender: UIButton, inCell cell: ItemCell) {
        guard
            let index = contentView.tableView.indexPath(for: cell),
            let tag = ItemCellButtonTagType(rawValue: sender.tag) else {
                return
        }

        let item = items[index.row]
        
        switch tag {
        case .delete:
            deleteConfirmation(forItem: item)
        case .increase:
            presenter.editAmount(forItem: item, increase: true)
        case .decrease:
            presenter.editAmount(forItem: item, increase: false)
        }
    }
}

// MARK: - UITableViewDelegate
extension ItemListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - UITableViewDelegate
extension ItemListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(cell: ItemCell.self, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ItemCell else { return }
        let item = items[indexPath.row]
        
        cell.title = item.title
        cell.desc = item.desc
        cell.category = ItemCategoryType(rawValue: item.category)
        cell.price = item.price
        cell.size = item.size
        cell.amount = Int(truncating: item.amount)
        
        cell.delegate = self
    }
}

// MARK: - Action Selector
private extension ItemListController {
    @objc
    func removeButtonDidTap() {
        let alertController = UIAlertController(
            title: "Delete All Items",
            message: "You are about to delete all stored. Are you sure you want to continue?",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
            title: "Proceed",
            style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.presenter.removeAllItems()
        })
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        alertController.view.tintColor = .black
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Price Helper
private extension ItemListController {
    func calculateTotalPrice(forItems items: [Item]) -> Double {
        var price: Double = 0.0
        
        items.forEach { item in
            price += item.price * Double(truncating: item.amount)
        }
        
        return price
    }
}
// MARK: - Setup View Appereance
private extension ItemListController {
    func setup() {
        title = "Cart Items"
        contentView.delegate = self
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(cell: ItemCell.self)
        
        contentView.backgroundColor = .white
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(removeButtonDidTap))
    }
    
    func deleteConfirmation(forItem item: Item) {
        let alertController = UIAlertController(
            title: "Remove Item",
            message: "You are about to remove \(item.title) item from list. Are you sure you want to continue?",
            preferredStyle: .alert)
        alertController.view.tintColor = .black
        
        alertController.addAction(
            UIAlertAction(
                title: "Delete",
                style: .destructive) { _ in
                    self.presenter.removeItem(item)
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        navigationController?.present(alertController, animated: true, completion: nil)
    }
}
