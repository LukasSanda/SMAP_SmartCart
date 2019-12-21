//
//  ManualAddPresenter.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 03/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol ManualAddPresenter {
    func load()
    func addItemToCart(_ item: ItemEntity, withController: ManualAddController)
    func showAddNewProduct(withController controller: ManualAddController)
}

internal protocol ManualAddDelegate: class {
    func didLoad(products: [ItemEntity])
    func presentController(_ controller: UIViewController)
    func showController(_ controller: UIViewController)
}

internal class ManualAddPresenterImpl: ManualAddPresenter {
    
    // MARK: - Private Properties
    
    private let getKnownProducts: GetKnownProducts
    private let coordinator: ManualAddCoordinator
    
    // MARK: - Internal Properties
    
    internal weak var delegate: ManualAddDelegate?
    
    // MARK: - Initialization
    
    internal init(coordinator: ManualAddCoordinator, getKnownProducts: GetKnownProducts) {
        self.coordinator = coordinator
        self.getKnownProducts = getKnownProducts
    }
    // MARK: - Protocol
    
    internal func load() {
        getKnownProducts.get { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                self.delegate?.didLoad(products: products
                    .sorted { $0.title.lowercased() < $1.title.lowercased() })
                
            case .failure(let error):
                logger.logError(message: error.localizedDescription)
            }
        }
    }
    
    internal func addItemToCart(_ item: ItemEntity, withController: ManualAddController) {
        delegate?.presentController(coordinator.presentAddItem(item, forController: withController))
    }
    
    internal func showAddNewProduct(withController controller: ManualAddController) {
        delegate?.showController(coordinator.showAddNewProduct())
    }
}
