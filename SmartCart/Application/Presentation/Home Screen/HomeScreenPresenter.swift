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
    
    private let cartRepository: CartRepository
    private let coordinator: HomeScreenCoordinator
    
    // MARK: - Internal Properties
    
    internal weak var delegate: HomeScreenDelegate?
    
    // MARK: - Initialization
    
    internal init(cartRepository: CartRepository, coordinator: HomeScreenCoordinator) {
        self.cartRepository = cartRepository
        self.coordinator = coordinator
    }
    
    internal func load() {
        cartRepository.loadCarts { [weak self] result in
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
        cartRepository.removeCart(cart) { [weak self] result in
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
        cartRepository.removeAllCarts { result in
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
        showDetail(forCart: cartRepository.addNewCart())
    }
    
    func showDetail(forCart cart: Cart) {
        coordinator.showDetail(forCart: cart)
    }
}
