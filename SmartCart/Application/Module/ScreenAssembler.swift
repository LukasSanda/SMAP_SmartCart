//
//  ScreenAssembler.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

extension ModuleAssembler: ScreenAssembly {
    
    func cartListController() -> CartListController {
        let coordinator = CartListCoordinatorImpl(
            commitChange: resolve(),
            getKnownProducts: resolve(),
            addItemProduct: resolve(),
            addItem: resolve(),
            marketsRepository: resolve(),
            cartRepository: resolve())
        let presenter = CartListPresenterImpl(
            loadCarts: resolve(),
            removeCart: resolve(),
            removeAllCarts: resolve(),
            createCart: resolve(),
            coordinator: coordinator)
        
        let controller = CartListController(presenter: presenter)
        presenter.delegate = controller
        return controller
    }
    
    func openLastCart() -> CartListController {
        let coordinator = CartListCoordinatorImpl(
            commitChange: resolve(),
            getKnownProducts: resolve(),
            addItemProduct: resolve(),
            addItem: resolve(),
            marketsRepository: resolve(),
            cartRepository: resolve())
        let presenter = CartListPresenterImpl(
            loadCarts: resolve(),
            removeCart: resolve(),
            removeAllCarts: resolve(),
            createCart: resolve(),
            coordinator: coordinator)
        
        let controller = CartListController(presenter: presenter)
        presenter.delegate = controller
        presenter.showLastCart()
        
        return controller
    }
}
