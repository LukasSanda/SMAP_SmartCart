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
    func showAddNewProduct() -> UIViewController
    func presentBarcodeScanner(forController itemListController: ItemListController) -> UIViewController
    func presentTitleScanner(forController itemListController: ItemListController) -> UIViewController
    func presentScannedItem(_ item: ItemEntity, forController controller: ItemListController) -> UIViewController
}

internal class ItemListCoordinatorImpl: ItemListCoordinator {
    
    // MARK: - Properties
    
    private let getKnownProducts: GetKnownProducts
    private let addItem: AddItem
    private let addItemProduct: AddItemProduct
    
    // MARK: - Initialization
    
    internal init(getKnownProducts: GetKnownProducts, addItem: AddItem, addItemProduct: AddItemProduct) {
        self.getKnownProducts = getKnownProducts
        self.addItem = addItem
        self.addItemProduct = addItemProduct
    }
    
    // MARK: - Protocol
    
    internal func presentManualAdd() -> UIViewController {
        let coordinator = ManualAddCoordinatorImpl(addItem: addItem, addItemProduct: addItemProduct)
        let presenter = ManualAddPresenterImpl(coordinator: coordinator, getKnownProducts: getKnownProducts)
        let controller = ManualAddController(presenter: presenter)
        presenter.delegate = controller
        return controller
    }
    
    internal func presentBarcodeScanner(forController itemListController: ItemListController) -> UIViewController {
        let presenter = BarcodeScannerPresenterImpl(getKnownProducts: getKnownProducts)
        let controller = BarcodeScannerController(presenter: presenter)
        presenter.delegate = itemListController
        return controller
    }
    
    func presentTitleScanner(forController itemListController: ItemListController) -> UIViewController {
        let presenter = TitleScannerPresenterImpl(getKnownProducts: getKnownProducts)
        let controller = TitleScannerController(presenter: presenter)
        presenter.delegate = itemListController
        return controller
    }
    
    internal func presentScannedItem(_ item: ItemEntity, forController controller: ItemListController) -> UIViewController {
        let presenter = AddItemPresenterImpl(addItem: addItem)
        presenter.delegate = controller
        let controller = AddItemController(presenter: presenter, item: item)
        return controller
    }
    
    internal func showAddNewProduct() -> UIViewController {
        let presenter = AddProductPresenterImpl(addItemProduct: addItemProduct)
        let controller = AddProductController(presenter: presenter)
        presenter.delegate = controller
        return controller
    }
}
