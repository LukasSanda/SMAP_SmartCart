//
//  ManualAddCoordinator.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol ManualAddCoordinator {
    func presentAddItem(_ item: ItemEntity, forController: ManualAddController) -> UIViewController
    func showAddNewProduct() -> UIViewController
}

internal class ManualAddCoordinatorImpl: ManualAddCoordinator {
    
    // MARK: - Private Properties
    
    private let addItem: AddItem
    private let addItemProduct: AddItemProduct
    
    // MARK: - Initialiation
    
    internal init(addItem: AddItem, addItemProduct: AddItemProduct) {
        self.addItem = addItem
        self.addItemProduct = addItemProduct
    }
    
    // MARK: - Protocol
    
    internal func presentAddItem(_ item: ItemEntity, forController: ManualAddController) -> UIViewController {
        let presenter = AddItemPresenterImpl(addItem: addItem)
        let controller = AddItemController(presenter: presenter, item: item)
        presenter.delegate = forController
        return controller
    }
    
    internal func showAddNewProduct() -> UIViewController {
        let presenter = AddProductPresenterImpl(addItemProduct: addItemProduct)
        let controller = AddProductController(presenter: presenter)
        presenter.delegate = controller
        return controller
    }
}
