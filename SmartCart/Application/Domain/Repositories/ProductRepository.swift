//
//  ProductRepository.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation
import CoreData

internal protocol ProductRepository {
    func getProducts(_ completion: @escaping (Result<Set<ItemEntity>, ProductError>) -> Void)
}

internal class ProductRepositoryImpl: ProductRepository {
    
    // MARK: - Properties
    
    private let databaseService: DatabaseService
    private let productService: ProductService
    
    private var cache: Set<ItemEntity>?
    
    // MARK: - Initialization
    
    internal init(service: DatabaseService, productService: ProductService) {
        self.databaseService = service
        self.productService = productService
        // Check for new products
        getProductsFromFile()
    }
    
    // MARK: - Protocol
    
    internal func getProducts(_ completion: @escaping (Result<Set<ItemEntity>, ProductError>) -> Void) {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            let products = try databaseService.viewContext.fetch(fetchRequest)
            let itemEntityArray = products.map { ItemEntity(product: $0) }
            
            let set = Set(itemEntityArray)
            self.cache = set
            
            completion(.success(set))
            
        } catch let error {
            completion(.failure(ProductError.nativeError(error)))
        }
    }
}

// MARK: - Check file for new products
private extension ProductRepositoryImpl {
    func getProductsFromFile() {
        productService.getItems { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let productsInFile):
                
                self.getProducts { result in
                    switch result {
                    case .success(let productsInDatabase):
                        // Find those products which are not in database
                        let productsNotInDatabase = productsInFile.filter { !productsInDatabase.contains($0) }
                        
                        // Store each product, not in database, to database
                        for product in productsNotInDatabase {
                            let newProduct = Product(context: self.databaseService.viewContext)
                            newProduct.ean = product.ean
                            newProduct.title = product.title
                            newProduct.desc = product.desc
                            newProduct.price = product.price
                            newProduct.category = product.category
                            newProduct.size = product.size
                            
                            self.databaseService.save()
                        }
                        
                    case .failure(let error):
                        logger.logError(message: error.localizedDescription)
                    }
                }
                
            case .failure(let error):
                logger.logError(message: error.localizedDescription)
            }
        }
    }
}
