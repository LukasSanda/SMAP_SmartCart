//
//  CreateNewCart.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 13/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol CreateNewCart {
    func create() -> Cart
}

internal class CreateNewCartImpl: CreateNewCart {
    
    // MARK: - Properties
    
    private let repository: CartRepository
    
    // MARK: - Initialization
    
    internal init(repository: CartRepository) {
        self.repository = repository
    }
    
    // MARK: - Protocol
    
    internal func create() -> Cart {
        return repository.addNewCart()
    }
}
