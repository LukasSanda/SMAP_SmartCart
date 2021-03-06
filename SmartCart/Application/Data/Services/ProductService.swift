//
//  ProductService.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol ProductService {
    func getItems(_ completion: @escaping (Result<Set<ItemEntity>, ProductError>) -> Void)
}

internal class ProductServiceImpl: ProductService {
    
    // MARK: - Initialization
    
    internal init() { }
    
    // MARK: - Protocol
    
    internal func getItems(_ completion: @escaping (Result<Set<ItemEntity>, ProductError>) -> Void) {
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
                    size: product["size"] as? String ?? "")
                result.insert(item)
            }
            
            completion(.success(result))
            
        } catch let error {
            completion(.failure(ProductError.nativeError(error)))
        }
    }
}
