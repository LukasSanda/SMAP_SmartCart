//
//  CartContentCoordinator.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 12/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol CartContentCoordinator {
    func presentScanner(forController cartContentController: CartContentController) -> UIViewController
}

internal class CartContentCoordinatorImpl: CartContentCoordinator {
    
    // MARK: - Initialization
    
    internal init() { }
    
    // MARK: - Protocol
    
    internal func presentScanner(forController cartContentController: CartContentController) -> UIViewController {
        let controller = ScannerViewController()
        controller.delegate = cartContentController
        return controller
    }
}
