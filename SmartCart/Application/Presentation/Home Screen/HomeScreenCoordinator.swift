//
//  HomeScreenCoordinator.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 11/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol HomeScreenCoordinator {
    func showDetail(forCart cart: Cart)
}

internal protocol HomeScreenCoordinatorDelegate: class {
    func showController(_ controller: UIViewController)
}

internal class HomeScreenCoordinatorImpl: HomeScreenCoordinator {
    
    // MARK: - Private Properties
    
    private let commitChange: CommitChange
    
    // MARK: - Internal Propertries
    
    internal weak var delegate: HomeScreenCoordinatorDelegate?
    
    // MARK: - Initialization
    
    internal init(commitChange: CommitChange) {
        self.commitChange = commitChange
    }
    
    // MARK: - Protocol
    
    internal func showDetail(forCart cart: Cart) {
        let coordinator = CartContentCoordinatorImpl()
        let presenter = CartContentPresenterImpl(cart: cart, commitChange: commitChange, coordinator: coordinator)
        let controller = CartContentController(presenter: presenter)
        presenter.delegate = controller
        delegate?.showController(controller)
    }
}
