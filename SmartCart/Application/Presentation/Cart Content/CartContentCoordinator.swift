//
//  CartContentCoordinator.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 12/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol CartContentCoordinator {
    func presentScanner(forController cartContentController: CartContentController) -> UIViewController
    func presentScannedItem(_ item: ItemEntity, forController controller: CartContentController) -> UIViewController
}

internal class CartContentCoordinatorImpl: CartContentCoordinator {
    
    // MARK: - Properties
    
    private let getKnownProducts: GetKnownProducts
    private let addItem: AddItem
    
    // MARK: - Initialization
    
    internal init(getKnownProducts: GetKnownProducts, addItem: AddItem) {
        self.getKnownProducts = getKnownProducts
        self.addItem = addItem
    }
    
    // MARK: - Protocol
    
    internal func presentScanner(forController cartContentController: CartContentController) -> UIViewController {
        let presenter = ScannerViewPresenterImpl(getKnownProducts: getKnownProducts)
        let controller = ScannerViewController(presenter: presenter)
        presenter.delegate = cartContentController
        return controller
    }
    
    internal func presentScannedItem(_ item: ItemEntity, forController controller: CartContentController) -> UIViewController {
        let presenter = AddItemPresenterImpl(addItem: addItem)
        presenter.delegate = controller
        let controller = AddItemController(presenter: presenter, item: item)
        return controller
    }
}
