//
//  CartListCoordinator.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 11/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol CartListCoordinator {
    func showDetail(forCart cart: Cart) -> UIViewController
    func presentSettings() -> UIViewController
}

internal class CartListCoordinatorImpl: CartListCoordinator {
    
    // MARK: - Private Properties
    
    private let commitChange: CommitChange
    private let getKnownProducts: GetKnownProducts
    private let addItem: AddItem
    private let addItemProduct: AddItemProduct
    private let marketsRepository: SupermarketRepository
    private let cartRepository: CartRepository
    
    // MARK: - Initialization
    
    internal init(commitChange: CommitChange,
                  getKnownProducts: GetKnownProducts,
                  addItemProduct: AddItemProduct,
                  addItem: AddItem,
                  marketsRepository: SupermarketRepository,
                  cartRepository: CartRepository) {
        self.commitChange = commitChange
        self.getKnownProducts = getKnownProducts
        self.addItem = addItem
        self.addItemProduct = addItemProduct
        self.marketsRepository = marketsRepository
        self.cartRepository = cartRepository
    }
    
    // MARK: - Protocol
    
    internal func showDetail(forCart cart: Cart) -> UIViewController {
        let coordinator = ItemListCoordinatorImpl(getKnownProducts: getKnownProducts, addItem: addItem, addItemProduct: addItemProduct)
        let presenter = ItemListPresenterImpl(cart: cart, commitChange: commitChange, coordinator: coordinator)
        let controller = ItemListController(presenter: presenter)
        presenter.delegate = controller
        return controller
    }
    
    internal func presentSettings() -> UIViewController {
        let presenter = SettingsPresenterImpl(marketsRepository: marketsRepository, cartRepository: cartRepository)
        let controller = SettingsController(presenter: presenter)
        presenter.delegate = controller
        return controller
    }
}
