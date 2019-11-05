//
//  CartRepository.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation
import CoreData

internal protocol CartRepository {
    func addCart(_ cart: Cart)
    func loadLastCart() -> Cart?
    func loadCarts() -> [Cart]?
}

internal class CartRepositoryImpl: CartRepository {
    
    // MARK: - Properties
    
    private let databaseService: DatabaseService
    
    // MARK: - Initialization
    
    internal init(service: DatabaseService) {
        self.databaseService = service
    }
    
    // MARK: - Protocol
    
    internal func addCart(_ cart: Cart) {
        databaseService.saveContext()
    }
    
    internal func loadLastCart() -> Cart? {
        return loadCarts()?.first
    }
    
    internal func loadCarts() -> [Cart]? {
        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        let primarySortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        
        do {
            let cart = try databaseService.viewContext.fetch(fetchRequest)
            return cart
            
        } catch let error {
            print(error)
        }
        
        return nil
    }
}
