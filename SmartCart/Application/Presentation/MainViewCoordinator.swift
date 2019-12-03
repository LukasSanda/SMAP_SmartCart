//
//  MainViewCoordinator.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol MainViewCoordinator {
    func showCartList()
}

internal class MainViewCoordinatorImpl: MainViewCoordinator {
    
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    private let screenAssembly: ScreenAssembly
    
    // MARK: - Initialization
    
    internal init(navigationController: UINavigationController, assembler: ScreenAssembly) {
        self.navigationController = navigationController
        self.screenAssembly = assembler
        setupNavigationBar()
    }
    
    // MARK: - Protocol
    
    internal func showCartList() {
        navigationController.show(screenAssembly.cartListController(), sender: nil)
    }
}

// MARK: - Setup Bar Appereance
private extension MainViewCoordinatorImpl {
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.shadowImage = nil
        appearance.shadowColor = nil

        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        navigationController.navigationBar.prefersLargeTitles = true
    }
}
