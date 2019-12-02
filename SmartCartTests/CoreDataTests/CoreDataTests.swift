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
        
        let item = Item(context: service.viewContext)
        item.ean = "1234556"
        item.title = "chocolate"
        item.desc = "description"
        item.price = 2.5
        item.category = ItemCategoryType.sweets.rawValue
        item.size = 0.05
        item.amount = NSDecimalNumber(value: 4)
        cart.addToItems(item)
        service.save()
        
        // Load property
        let repository = CartRepositoryImpl(service: service)
        let loadLastCart = LoadLastCartImpl(repository: repository)
        loadLastCart.load { result in
            switch result {
            case .success(let cart):
                XCTAssertNotNil(cart, "Should be loaded!")
            case .failure:
                XCTFail("Should not happened!")
            }
        }
        
    }
}
