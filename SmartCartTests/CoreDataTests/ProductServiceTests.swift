//
//  ProductServiceTests.swift
//  SmartCartTests
//
//  Created by Lukáš Šanda on 04/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import XCTest
@testable import SmartCart


class ProductServiceTests: XCTestCase {
    
    // MARK: - Methods
    
    func test_add_new_product_works_correctly() {
        let newItem = ItemEntity(
            ean: "asdqwertz",
            title: "Marmeláda",
            desc: "Jahodová",
            price: 34.5,
            category: ItemCategoryType.sweets.rawValue,
            size: 0.5)
        
        let productCache = ProductServiceImpl()
        let useCase = AddItemProductImpl(productService: productCache)
        useCase.add(newItem) { result in
            switch result {
            case .success:
                productCache.getItems(forceLoad: true) { result in
                    switch result {
                    case .success(let products):
                        XCTAssertTrue(products.contains(newItem), "Should contains newItem!")
                        
                    case .failure:
                        XCTFail("Should not fail!")
                    }
                }
                
            case .failure:
                XCTFail("Should not fail!")
            }
        }
    }
}
