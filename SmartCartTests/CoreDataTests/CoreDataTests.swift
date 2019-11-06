//
//  CoreDataTests.swift
//  SmartCartTests
//
//  Created by Lukáš Šanda on 04/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import XCTest
@testable import SmartCart
import CoreData

class CoreDataTests: XCTestCase {
    
    // MARK: - Properties
    
    private var service = DatabaseServiceImpl()
    
    // MARK: - Methods
    
    func test_should_save_cart_properly() {
        let cart = Cart(context: service.viewContext)
        cart.created = Date()
        cart.title = "test cart"
        
        let item = Item(context: service.viewContext)
        item.ean = "1234556"
        item.title = "chocolate"
        item.desc = "description"
        item.price = 2.5
        item.category = ItemCategoryType.sweets.rawValue
        item.size = 0.05
        cart.addToItems(item)
        service.saveContext()
        
        // Load property
        let repository = CartRepositoryImpl(service: service)
        let lastCart = repository.loadLastCart()
        XCTAssertNotNil(lastCart, "Should be loaded!")
        XCTAssertTrue(lastCart?.title == "test cart", "Property is not set properly!")
    }
}
