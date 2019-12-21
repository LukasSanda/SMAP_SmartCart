//
//  CartListPresenter.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol CartListPresenter {
    func load()
    func removeCart(_ cart: Cart)
    func createNewCart()
    func showDetail(forCart cart: Cart)
    func showMenu()
    func showLastCart()
}

internal protocol CartListDelegate: class {
    func didLoadAvailableCarts(_ carts: [Cart])
    func showController(_ controller: UIViewController)
    func presentController(_ controller: UIViewController)
}

internal class CartListPresenterImpl: CartListPresenter {
    
    // MARK: - Private Properties
    
    private var didLoadCarts: Bool = false
    
    private let loadCarts: LoadAllCarts
    private let removeCart: RemoveCart
    private let removeAllCarts: RemoveAllCarts
    private let createCart: CreateNewCart
    private let coordinator: CartListCoordinator
    
    // MARK: - Internal Properties
    
    internal weak var delegate: CartListDelegate?
    
    // MARK: - Initialization
    
    internal init(loadCarts: LoadAllCarts, removeCart: RemoveCart, removeAllCarts: RemoveAllCarts, createCart: CreateNewCart, coordinator: CartListCoordinator) {
        self.loadCarts = loadCarts
        self.removeCart = removeCart
        self.removeAllCarts = removeAllCarts
        self.createCart = createCart
        self.coordinator = coordinator
    }
    
    internal func load() {
        didLoadCarts = false
        
        loadCarts.load { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let carts):
                self.didLoadCarts = !carts.isEmpty
                self.delegate?.didLoadAvailableCarts(carts)
                
            case .failure(let error):
                logger.logError(message: (error as? DataError)?.localizedDescription ?? error.localizedDescription)
            }
        }
    }
    
    internal func removeCart(_ cart: Cart) {
        let alertController = UIAlertController(
            title: "Remove Item",
            message: "You are about to delete selected cart. Are you sure you want to continue?",
            preferredStyle: .alert)
        alertController.view.tintColor = .black
        
        alertController.addAction(UIAlertAction(
            title: "Delete",
            style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.deleteCart(cart)
            })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        delegate?.presentController(alertController)
        
    }
    
    internal func removeCarts() {
        let alertController = UIAlertController(
            title: "Delete All Carts",
            message: "You are about to delete all available carts. Are you sure you want to continue?",
            preferredStyle: .alert)
        alertController.view.tintColor = .black
        
        alertController.addAction(UIAlertAction(
            title: "Proceed",
            style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.deleteAllCarts()
        })
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        
        
        delegate?.presentController(alertController)
    }
    
    internal func createNewCart() {
        showDetail(forCart: createCart.create())
    }
    
    internal func showDetail(forCart cart: Cart) {
        delegate?.showController(coordinator.showDetail(forCart: cart))
    }
    
    internal func showMenu() {
        let controller = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        controller.view.tintColor = .black
        
        if didLoadCarts {
            controller.addAction(UIAlertAction(
            title: "Delete All",
            style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.removeCarts()
            })
        }
    
        controller.addAction(UIAlertAction(
            title: "Settings",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.showController(self.coordinator.presentSettings())
            })
        controller.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        
        delegate?.presentController(controller)
    }
    
    internal func showLastCart() {
        DispatchQueue.main.async {
            self.loadCarts.load { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let carts):
                    var lastCart: Cart?
                    
                    for cart in carts {
                        if cart.items?.allObjects.isEmpty ?? true { continue }
                        lastCart = cart
                    }
                    
                    guard let cart = lastCart else { return }
                    
                    self.delegate?.showController(self.coordinator.showDetail(forCart: cart))
                    
                case .failure(let error):
                    logger.logError(message: (error as? DataError)?.localizedDescription ?? error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Remove Cart/s
private extension CartListPresenterImpl {
    func deleteCart(_ cart: Cart) {
        removeCart.remove(cart: cart) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.load()
            case .failure(let error):
                logger.logError(message: error.localizedDescription)
            }
        }
    }
    
    func deleteAllCarts() {
        removeAllCarts.remove { result in
            switch result {
            case .success:
                self.load()
                
            case .failure(let error):
                logger.logError(message: error.localizedDescription)
            
            }
        }
    }
}
