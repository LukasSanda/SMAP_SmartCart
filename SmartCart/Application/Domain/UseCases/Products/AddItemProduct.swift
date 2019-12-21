//
//  AddItemProduct.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol AddItemProduct {
    func add(_ item: ItemEntity, _ completion: @escaping () -> Void)
}

internal class AddItemProductImpl: AddItemProduct {
    
    // MARK: - Private Properties
    
    private let productRepository: ProductRepository
    
    // MARK: - Initialization
    
    internal init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    // MARK: - Protocol
    
    internal func add(_ item: ItemEntity, _ completion: @escaping () -> Void) {
        productRepository.addProduct(itemEntity: item, completion)
    }
}
