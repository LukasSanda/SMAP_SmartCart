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
    func addNewCart() -> Cart
    func loadCarts(_ completion: @escaping (Result<[Cart], Error>) -> Void)
    func loadLastCart(_ completion: @escaping (Result<Cart, Error>) -> Void)
    func removeAllCarts(_ completion: @escaping (Result<Void, Error>) -> Void)
    func removeCart(_ cart: Cart, _ completion: @escaping (Result<Void, Error>) -> Void)
}

internal class CartRepositoryImpl: CartRepository {
    
    // MARK: - Properties
    
    private let databaseService: DatabaseService
    
    // MARK: - Initialization
    
    internal init(service: DatabaseService) {
        self.databaseService = service
    }
    
    // MARK: - Protocol
    
    internal func addNewCart() -> Cart {
        let cart = Cart(context: databaseService.viewContext)
        cart.created = Date()
        cart.id = Date().hashValue.description
        
        databaseService.save()
        return cart
    }
    
    internal func loadCarts(_ completion: @escaping (Result<[Cart], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        let primarySortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        
        do {
            let carts = try databaseService.viewContext.fetch(fetchRequest)
            completion(.success(carts))
            
        } catch let error {
            completion(.failure(error))
        }
    }
    
    internal func loadLastCart(_ completion: @escaping (Result<Cart, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        let primarySortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        fetchRequest.fetchLimit = 1
        
        do {
            let carts = try databaseService.viewContext.fetch(fetchRequest)
            guard let lastCart = carts.first else {
                completion(.failure(DataError.loadData))
                return
            }
            
            completion(.success(lastCart))
            
        } catch let error {
            completion(.failure(error))
        }
    }
    
    internal func removeAllCarts(_ completion: @escaping (Result<Void, Error>) -> Void) {
        databaseService.removeAll { result in
            completion(result)
        }
    }
    
    internal func removeCart(_ cart: Cart, _ completion: @escaping (Result<Void, Error>) -> Void) {
        databaseService.removeObject(cart) { result in
            completion(result)
        }
    }
}
