//
//  HomeScreenPresenter.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol HomeScreenPresenter {
    func load()
    func removeCart(_ cart: Cart)
    func removeAllCarts(_ completion: @escaping () -> Void)
    func createNewCart()
    func showDetail(forCart cart: Cart)
}

internal protocol HomeScreenDelegate: class {
    func didLoadAvailableCarts(_ carts: [Cart])
}

internal class HomeScreenPresenterImpl: HomeScreenPresenter {
    
    // MARK: - Private Properties
    
    private let loadCarts: LoadAllCarts
    private let removeCart: RemoveCart
    private let removeAllCarts: RemoveAllCarts
    private let createCart: CreateNewCart
    private let coordinator: HomeScreenCoordinator
    
    // MARK: - Internal Properties
    
    internal weak var delegate: HomeScreenDelegate?
    
    // MARK: - Initialization
    
    internal init(loadCarts: LoadAllCarts, removeCart: RemoveCart, removeAllCarts: RemoveAllCarts, createCart: CreateNewCart, coordinator: HomeScreenCoordinator) {
        self.loadCarts = loadCarts
        self.removeCart = removeCart
        self.removeAllCarts = removeAllCarts
        self.createCart = createCart
        self.coordinator = coordinator
    }
    
    internal func load() {
        loadCarts.load { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let carts):
                self.delegate?.didLoadAvailableCarts(carts)
                
            case .failure(let error):
                logger.logError(
                    inFunction: "loadAvailableCarts",
                    message: (error as? DataError)?.localizedDescription ?? error.localizedDescription)
            }
        }
    }
    
    internal func removeCart(_ cart: Cart) {
        removeCart.remove(cart: cart) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.load()
            case .failure(let error):
                logger.logError(
                    inFunction: "removeCart",
                    message: error.localizedDescription)
            
            }
        }
    }
    
    internal func removeAllCarts(_ completion: @escaping () -> Void) {
        removeAllCarts.remove { result in
            switch result {
            case .success:
                completion()
            case .failure(let error):
                logger.logError(
                    inFunction: "removeAllCarts",
                    message: error.localizedDescription)
            
            }
        }
    }
    
    internal func createNewCart() {
        showDetail(forCart: createCart.create())
    }
    
    func showDetail(forCart cart: Cart) {
        coordinator.showDetail(forCart: cart)
    }
}
