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
        let presenter = HomeScreenPresenterImpl(cartRepository: resolve())
        let coordinator = HomeScreenCoordinatorImpl(databaseService: resolve())
        let controller = HomeScreenController(presenter: presenter, coordinator: coordinator)
        presenter.delegate = controller
        coordinator.delegate = controller
        return controller
    }
}
