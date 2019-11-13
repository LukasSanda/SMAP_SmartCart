//
//  CartContentPresenter.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol CartContentPresenter {
    func load()
    func removeItem(_ item: Item)
    func removeAllItems()
    func editAmount(forItem item: Item, increase: Bool)
    func presentScanner(forController controller: CartContentController)
}

internal protocol CartContentDelegate: class {
    func didLoadItems(_ items: [Item])
    func removingItemDelegate(_ item: Item)
    func presentController(_ controller: UIViewController)
}

internal class CartContentPresenterImpl: CartContentPresenter {
    
    // MARK: - Private Properties
    
    private let cart: Cart
    private let databaseService: DatabaseService
    private let coordinator: CartContentCoordinator
    
    // MARK: - Internal Properties
    
    internal weak var delegate: CartContentDelegate?
    
    // MARK: - Initialization
    
    internal init(cart: Cart, databaseService: DatabaseService, coordinator: CartContentCoordinator) {
        self.cart = cart
        self.databaseService = databaseService
        self.coordinator = coordinator
    }
    
    // MARK: - Protocol
    
    internal func load() {
        guard let items = cart.items?.allObjects as? [Item] else {
            logger.logError(inFunction: "load", message: "Could not map items to an array.")
            return
        }
        
        delegate?.didLoadItems(items)
    }
    
    internal func removeAllItems() {
        guard let items = cart.items else { return }
        cart.removeFromItems(items)
        databaseService.save()
        load()
    }
    internal func removeItem(_ item: Item) {
        cart.removeFromItems(item)
        databaseService.save()
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
            }
        }
        
        load()
    }
    
    internal func presentScanner(forController controller: CartContentController) {
        delegate?.presentController(coordinator.presentScanner(forController: controller))
    }
}