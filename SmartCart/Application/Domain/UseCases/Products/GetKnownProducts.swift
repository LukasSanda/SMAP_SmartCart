//
//  GetKnownProducts.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 15/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol GetKnownProducts {
    func get(_ completion: @escaping (Result<Set<ItemEntity>, ProductError>) -> Void)
}

internal class GetKnownProductsImpl: GetKnownProducts {
    
    // MARK: - Properties
    
    private let cacheService: ProductCacheService
    
    // MARK: - Initialization
    
    internal init(cacheService: ProductCacheService) {
        self.cacheService = cacheService
    }
    
    // MARK: - Protocol
    
    internal func get(_ completion: @escaping (Result<Set<ItemEntity>, ProductError>) -> Void) {
        cacheService.getItems { result in
            switch result {
            case .success(let products):
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
