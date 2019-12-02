//
//  ProductCacheService.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol ProductCacheService {
    func getItems(_ completion: @escaping (Result<Set<ItemEntity>, ProductError>) -> Void)
    func addItem(_ item: ItemEntity)
}

internal class ProductCacheServiceImpl: ProductCacheService {
    
    // MARK: - Properties
    
    
    private var cache: Set<ItemEntity>?
    
    // MARK: - Initialization
    
    internal init() { }
    
    // MARK: - Protocol
    
    internal func getItems(_ completion: @escaping (Result<Set<ItemEntity>, ProductError>) -> Void) {
        if let cache = cache {
            completion(.success(cache))
            
        } else {
            var result = Set<ItemEntity>()
            
            guard let path = Bundle.main.path(forResource: "products", ofType: "json") else {
                completion(.failure(ProductError.noFile))
                return
            }
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                guard let json = jsonResult as? Dictionary<String, AnyObject>,
                    let products = json["products"] as? [Dictionary<String, AnyObject>] else {
                        completion(.failure(ProductError.parsing))
                        return
                }
                
                for product in products {
                    let item = ItemEntity(
                        ean: product["ean"] as? String ?? "",
                        title: product["title"] as? String ?? "",
                        desc: product["description"] as? String ?? "",
                        price: product["price"] as? Double ?? 0.0,
                        category: product["category"] as? String ?? "",
                        size: product["size"] as? Double ?? 0.0)
                    result.insert(item)
                }
                
                cache = result
                completion(.success(result))
                
            } catch let error {
                completion(.failure(ProductError.nativeError(error)))
            }
        }
    }
    
    internal func addItem(_ item: ItemEntity) {
        if var cache = cache {
            cache.insert(item)
            guard let file = FileHandle(forWritingAtPath: "products.json") else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: cache, options: .init(rawValue: 0))
                file.write(jsonData)
            } catch let error {
                logger.logError(message: error.localizedDescription)
            }
            
            file.closeFile()
            
        } else {
            
            getItems { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .failure(let error):
                    logger.logError(message: error.localizedDescription)
                case .success:
                    self.addItem(item)
                }
                
            }
            
        }
    }
}
