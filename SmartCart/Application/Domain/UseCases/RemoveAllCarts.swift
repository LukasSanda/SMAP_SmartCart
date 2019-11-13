//
//  RemoveAllCarts.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 13/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol RemoveAllCarts {
    func remove(_ completion: @escaping (Result<Void, Error>) -> Void)
}

internal class RemoveAllCartsImpl: RemoveAllCarts {
    
    // MARK: - Properties
    
    private let repository: CartRepository
    
    // MARK: - Initialization
    
    internal init(repository: CartRepository) {
        self.repository = repository
    }
    
    // MARK: - Protocol
    
    internal func remove(_ completion: @escaping (Result<Void, Error>) -> Void) {
        repository.removeAllCarts { result in
            completion(result)
        }
    }
}
