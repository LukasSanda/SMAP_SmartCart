//
//  AddItemProduct.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol AddItemProduct {
    func add(_ item: ItemEntity, _ completion: @escaping (Result<Void, ProductError>) -> Void)
}

internal class AddItemProductImpl: AddItemProduct {
    
    // MARK: - Private Properties
    
    private let productService: ProductService
    
    // MARK: - Initialization
    
    internal init(productService: ProductService) {
        self.productService = productService
    }
    
    // MARK: - Protocol
    
    internal func add(_ item: ItemEntity, _ completion: @escaping (Result<Void, ProductError>) -> Void) {
//        productService.addItem(item) { result in
//            switch result {
//            case .success:
//                completion(.success(()))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
}
