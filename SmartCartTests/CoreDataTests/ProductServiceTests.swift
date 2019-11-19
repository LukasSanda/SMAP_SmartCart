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
    
    func test_data_are_properly_fetched() {
        let service = ProductCacheServiceImpl()
        let items = service.getItems()
        XCTAssertNotNil(items, "Products should be loaded!")
    }
}
