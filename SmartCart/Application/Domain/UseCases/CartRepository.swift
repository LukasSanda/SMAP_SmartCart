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
    func loadLastCart(_ completion: @escaping (Result<Cart, Error>) -> Void)
    func loadCarts(_ completion: @escaping (Result<[Cart], Error>) -> Void)
    func removeAllCarts(_ completion: @escaping (Result<Void, Error>) -> Void)
    func removeCart(_ cart: Cart, _ completion: @escaping (Result<Void, Error>) -> Void)
}

internal class CartRepositoryImpl: CartRepository {
    
    // MARK: - Properties
    
    private let databaseService: DatabaseService
    
    // MARK: - Initialization
    
    internal init(service: DatabaseService) {
        self.databaseService = service
        initMockData()
    }
    
    // MARK: - Protocol
    
    internal func addNewCart() -> Cart {
        let cart = Cart(context: databaseService.viewContext)
        cart.created = Date()
        cart.id = Date().hashValue.description
        
        databaseService.save()
        return cart
    }
    
    internal func loadLastCart(_ completion: @escaping (Result<Cart, Error>) -> Void) {
        loadCarts { result in
            switch result {
            case .success(let carts):
                guard let cart = carts.first else {
                    completion(.failure(DataError.noData))
                    return
                }
                
                completion(.success(cart))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
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

private extension CartRepositoryImpl {
    func initMockData() {
        databaseService.removeAll { _ in
            for _ in 1...10 {
                let cart = Cart(context: self.databaseService.viewContext)
                cart.id = Date().hashValue.description
                cart.created = Date(timeIntervalSinceNow: TimeInterval(-(Int.random(in: 100000...10000000))))
                
                for y in 1...10 {
                    let item = Item(context: self.databaseService.viewContext)
                    item.id = Date().hashValue.description
                    item.title = "title \(y.description)"
                    item.ean = "EAN\(y.description)"
                    item.desc = "desc"
                    item.category = y % 2 == 0 ? ItemCategoryType.snacks.rawValue : ItemCategoryType.drinks.rawValue
                    item.price = Double(y) * 2.5
                    item.size = Double(y) * 4.5
                    item.amount = NSDecimalNumber(value: y)
                    
                    cart.addToItems(item)
                }
            }
            
            self.databaseService.save()
        }
    }
}
