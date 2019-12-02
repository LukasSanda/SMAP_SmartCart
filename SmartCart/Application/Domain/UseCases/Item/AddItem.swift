//
//  AddItem.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 01/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol AddItem {
    func add(_ item: ItemEntity, ofAmount amount: Int, _ completion: @escaping (Result<Void, Error>) -> Void)
}

internal class AddItemImpl: AddItem {
    
    // MARK: - Properties
    
    private let loadLastCart: LoadLastCart
    private let databaseService: DatabaseService
    
    // MARK: - Initialization
    
    internal init(loadLastCart: LoadLastCart, databaseService: DatabaseService) {
        self.loadLastCart = loadLastCart
        self.databaseService = databaseService
    }
    
    // MARK: - Protocol
    
    internal func add(_ item: ItemEntity, ofAmount amount: Int, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        loadLastCart.load { result in
            switch result {
            case .success(let cart):
                if self.checkItemIfAlreadyExists(item, inCart: cart) {
                    cart.items?.forEach { storedItem in
                        guard let storedItem = storedItem as? Item, storedItem.ean == item.ean else { return }
                        
                        let newValue = Int(truncating: storedItem.amount) + amount
                        storedItem.amount = NSDecimalNumber(value: newValue)
                    }
                    
                } else {
                    let newItem = Item(context: self.databaseService.viewContext)
                    newItem.setProperties(withItemEntity: item, ofAmount: amount)
                    
                    cart.addToItems(newItem)
                }
                
                self.databaseService.save()
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension AddItemImpl {
    func checkItemIfAlreadyExists(_ item: ItemEntity, inCart cart: Cart) -> Bool {
        return cart.items?.allObjects.contains(where: { storedItem in
            (storedItem as? Item)?.ean == item.ean
        }) ?? false
    }
}
