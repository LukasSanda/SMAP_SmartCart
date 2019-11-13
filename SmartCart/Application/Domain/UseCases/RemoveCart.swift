//
//  RemoveCart.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 13/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol RemoveCart {
    func remove(cart: Cart, _ completion: @escaping (Result<Void, Error>) -> Void)
}

internal class RemoveCartImpl: RemoveCart {
    
    // MARK: - Properties
    
    private let repository: CartRepository
    
    // MARK: - Initialization
    
    internal init(repository: CartRepository) {
        self.repository = repository
    }
    
    // MARK: - Protocol
    
    internal func remove(cart: Cart, _ completion: @escaping (Result<Void, Error>) -> Void) {
        repository.removeCart(cart) { result in
            completion(result)
        }
    }
}
