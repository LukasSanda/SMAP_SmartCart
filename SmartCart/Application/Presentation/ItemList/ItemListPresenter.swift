//
//  ItemListPresenter.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol ItemListPresenter {
    func load()
    func removeItem(_ item: Item)
    func removeAllItems()
    func editAmount(forItem item: Item, increase: Bool)
    func presentManualAdd()
    func presentTitleScanner(forController controller: ItemListController)
    func presentBarcodeScanner(forController controller: ItemListController)
    func presentScannedItem(_ item: ItemEntity, forController controller: ItemListController)
    func didNotRecognizeItem(scannedWithBarcode: Bool, forController controller: ItemListController)
    func presentAddNewProduct()
}

internal protocol ItemListDelegate: class {
    func didLoadItems(_ items: [Item])
    func removingItemDelegate(_ item: Item)
    func presentController(_ controller: UIViewController)
    func showController(_ controller: UIViewController)
}

internal class ItemListPresenterImpl: ItemListPresenter {
    
    // MARK: - Private Properties
    
    private let cart: Cart
    private let commitChange: CommitChange
    private let coordinator: ItemListCoordinator
    
    // MARK: - Internal Properties
    
    internal weak var delegate: ItemListDelegate?
    
    // MARK: - Initialization
    
    internal init(cart: Cart, commitChange: CommitChange, coordinator: ItemListCoordinator) {
        self.cart = cart
        self.commitChange = commitChange
        self.coordinator = coordinator
    }
    
    // MARK: - Protocol
    
    internal func load() {
        guard let items = cart.items?.allObjects as? [Item] else {
            logger.logError(message: "Could not map items to an array.")
            return
        }
        
        delegate?.didLoadItems(items)
    }
    
    internal func removeAllItems() {
        guard let items = cart.items else { return }
        cart.removeFromItems(items)
        commitChange.commit()
        load()
    }
    internal func removeItem(_ item: Item) {
        cart.removeFromItems(item)
        commitChange.commit()
        load()
    }
    
    internal func editAmount(forItem item: Item, increase: Bool) {
        cart.items?.forEach { element in
            guard let element = element as? Item else { return }
            
            if element == item {
                let amount = Int(truncating: item.amount)
                let newValue = increase ? amount + 1 : amount - 1
                
                guard newValue != 0 else {
                    self.delegate?.removingItemDelegate(item)
                    return
                }
                
                item.amount  = NSDecimalNumber(value: newValue)
                commitChange.commit()
            }
        }
        
        load()
    }
    
    internal func presentManualAdd() {
        delegate?.showController(coordinator.presentManualAdd())
    }
    
    internal func presentAddNewProduct() {
        delegate?.showController(coordinator.showAddNewProduct())
    }
    
    internal func presentBarcodeScanner(forController controller: ItemListController) {
        delegate?.presentController(coordinator.presentBarcodeScanner(forController: controller))
    }
    
    internal func presentTitleScanner(forController controller: ItemListController) {
        delegate?.presentController(coordinator.presentTitleScanner(forController: controller))
    }
    
    internal func presentScannedItem(_ item: ItemEntity, forController controller: ItemListController) {
        delegate?.presentController(coordinator.presentScannedItem(item, forController: controller))
    }
    
    internal func didNotRecognizeItem(scannedWithBarcode: Bool, forController controller: ItemListController) {
        let alertController = UIAlertController(
            title: "Scanned Unkwnown Product",
            message: "You have scanned product that we probably dont have in our database. Please, retake the photo or add this product manually.",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(
            title: "Add",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.presentAddNewProduct()
        })
        
        
        alertController.addAction(UIAlertAction(
            title: "Retake",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                if scannedWithBarcode {
                    self.presentBarcodeScanner(forController: controller)
                } else {
                    self.presentTitleScanner(forController: controller)
                }
        })
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        
        delegate?.presentController(alertController)
    }
}
