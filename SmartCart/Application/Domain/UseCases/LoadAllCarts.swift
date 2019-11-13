//
//  LoadAllCarts.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 13/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol LoadAllCarts {
    func load(_ completion: @escaping (Result<[Cart], Error>) -> Void)
}

internal class LoadAllCartsImpl: LoadAllCarts {
    
    // MARK: - Properties
    
    private let repository: CartRepository
    
    // MARK: - Initialization
    
    internal init(repository: CartRepository) {
        self.repository = repository
    }
    
    // MARK: - Protocol
    
    internal func load(_ completion: @escaping (Result<[Cart], Error>) -> Void) {
        repository.loadCarts { result in
            completion(result)
        }
    }
}
