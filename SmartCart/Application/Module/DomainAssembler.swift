//
//  DomainAssembler.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

extension ModuleAssembler: DomainAssembly {
    // MARK: - Services
    func resolve() -> DatabaseService {
        if let databaseService = databaseService {
            return databaseService
        }
        
        let databaseService = DatabaseServiceImpl()
        self.databaseService = databaseService
        return databaseService
    }
    
    func resolve() -> ProductService {
        if let cacheService = productService {
            return cacheService
        }
        
        let cacheService = ProductServiceImpl()
        self.productService = cacheService
        return cacheService
    }
    
    // MARK: - Repositories
    func resolve() -> CartRepository {
        return CartRepositoryImpl(service: resolve())
    }
    
    func resolve() -> ProductRepository {
        return ProductRepositoryImpl(service: resolve(), productService: resolve())
    }
    
    func resolve() -> SupermarketRepository {
        return SupermarketRepositoryImpl()
    }
    
    // MARK: - Use-Cases Cart
    func resolve() -> CreateNewCart {
        return CreateNewCartImpl(repository: resolve())
    }
    
    func resolve() -> LoadLastCart {
        return LoadLastCartImpl(repository: resolve())
    }
    
    func resolve() -> LoadAllCarts {
        return LoadAllCartsImpl(repository: resolve())
    }
    
    func resolve() -> RemoveAllCarts {
        return RemoveAllCartsImpl(repository: resolve())
    }
    
    func resolve() -> RemoveCart {
        return RemoveCartImpl(repository: resolve())
    }
    
    // MARK: - Use-Cases Database
    func resolve() -> CommitChange {
        return CommitChangeImpl(service: resolve())
    }
    
    // MARK: - Use-Cases Products
    func resolve() -> GetKnownProducts {
        return GetKnownProductsImpl(repository: resolve())
    }
    
    func resolve() -> AddItem {
        return AddItemImpl(loadLastCart: resolve(), databaseService: resolve())
    }
    
    func resolve() -> AddItemProduct {
        return AddItemProductImpl(productRepository: resolve())
    }
}
