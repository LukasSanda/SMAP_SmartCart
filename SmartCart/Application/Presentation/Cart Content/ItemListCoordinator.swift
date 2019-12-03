//
//  ItemListCoordinator.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 12/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol ItemListCoordinator {
    func presentManualAdd() -> UIViewController
    func presentScanner(forController itemListController: ItemListController) -> UIViewController
    func presentScannedItem(_ item: ItemEntity, forController controller: ItemListController) -> UIViewController
}

internal class ItemListCoordinatorImpl: ItemListCoordinator {
    
    // MARK: - Properties
    
    private let getKnownProducts: GetKnownProducts
    private let addItem: AddItem
    
    // MARK: - Initialization
    
    internal init(getKnownProducts: GetKnownProducts, addItem: AddItem) {
        self.getKnownProducts = getKnownProducts
        self.addItem = addItem
    }
    
    // MARK: - Protocol
    
    internal func presentManualAdd() -> UIViewController {
        let coordinator = ManualAddCoordinatorImpl(addItem: addItem)
        let presenter = ManualAddPresenterImpl(coordinator: coordinator, getKnownProducts: getKnownProducts)
        let controller = ManualAddController(presenter: presenter)
        presenter.delegate = controller
        return controller
    }
    
    internal func presentScanner(forController itemListController: ItemListController) -> UIViewController {
        let presenter = ScannerViewPresenterImpl(getKnownProducts: getKnownProducts)
        let controller = ScannerViewController(presenter: presenter)
        presenter.delegate = itemListController
        return controller
    }
    
    internal func presentScannedItem(_ item: ItemEntity, forController controller: ItemListController) -> UIViewController {
        let presenter = AddItemPresenterImpl(addItem: addItem)
        presenter.delegate = controller
        let controller = AddItemController(presenter: presenter, item: item)
        return controller
    }
}
