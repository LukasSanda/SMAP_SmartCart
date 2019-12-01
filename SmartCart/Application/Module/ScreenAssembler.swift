//
//  ScreenAssembler.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

extension ModuleAssembler: ScreenAssembly {
    
    func homeScreenController() -> HomeScreenController {
        let coordinator = HomeScreenCoordinatorImpl(commitChange: resolve())
        
        let presenter = HomeScreenPresenterImpl(
            loadCarts: resolve(),
            removeCart: resolve(),
            removeAllCarts: resolve(),
            createCart: resolve(),
            coordinator: coordinator)
        
        let controller = HomeScreenController(presenter: presenter)
        presenter.delegate = controller
        coordinator.delegate = controller
        return controller
    }
}
