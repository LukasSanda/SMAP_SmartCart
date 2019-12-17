//
//  CartListCoordinator.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 11/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol CartListCoordinator {
    func showDetail(forCart cart: Cart)
}

internal protocol CartListCoordinatorDelegate: class {
    func showController(_ controller: UIViewController)
}

internal class CartListCoordinatorImpl: CartListCoordinator {
    
    // MARK: - Private Properties
    
    private let commitChange: CommitChange
    private let getKnownProducts: GetKnownProducts
    private let addItem: AddItem
    private let addItemProduct: AddItemProduct
    
    // MARK: - Internal Propertries
    
    internal weak var delegate: CartListCoordinatorDelegate?
    
    // MARK: - Initialization
    
    internal init(commitChange: CommitChange, getKnownProducts: GetKnownProducts, addItemProduct: AddItemProduct, addItem: AddItem) {
        self.commitChange = commitChange
        self.getKnownProducts = getKnownProducts
        self.addItem = addItem
        self.addItemProduct = addItemProduct
    }
    
    // MARK: - Protocol
    
    internal func showDetail(forCart cart: Cart) {
        let coordinator = ItemListCoordinatorImpl(getKnownProducts: getKnownProducts, addItem: addItem, addItemProduct: addItemProduct)
        let presenter = ItemListPresenterImpl(cart: cart, commitChange: commitChange, coordinator: coordinator)
        let controller = ItemListController(presenter: presenter)
        presenter.delegate = controller
        delegate?.showController(controller)
    }
}
