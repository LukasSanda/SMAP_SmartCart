//
//  ProductCacheService.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol ProductService {
    func getItems() -> [ItemEntity]?
    func addItem(_ item: ItemEntity)
}

internal class ProductServiceImpl: ProductService {
    
    // MARK: - Constats
    
    private enum Keys {
        static let products = "ProductService.products"
    }
    
    private let fetchLimit: TimeInterval = 300
    private var lastTimeFetched: Date?
    
    // MARK: - Properties
    
    
    private var cache: [ItemEntity]?
    private var isCacheValid: Bool {
        guard let fetched = lastTimeFetched else {
            return false
        }
        
        return Date().timeIntervalSince(fetched) < fetchLimit
    }
    
    // MARK: - Initialization
    
    internal init() { }
    
    // MARK: - Protocol
    
    internal func getItems() -> [ItemEntity]? {
        if let _ = cache, isCacheValid {
            return cache
        }
        
        var result = [ItemEntity]()
        
        guard let path = Bundle.main.path(forResource: "products", ofType: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            guard let json = jsonResult as? Dictionary<String, AnyObject>,
                let products = json["products"] as? [Dictionary<String, AnyObject>] else {
                    return nil
            }
            
            for product in products {
                let item = ItemEntity(
                    ean: product["ean"] as? String ?? "",
                    title: product["title"] as? String ?? "",
                    desc: product["description"] as? String ?? nil,
                    price: product["price"] as? Double ?? nil,
                    category: product["category"] as? String ?? "",
                    size: product["size"] as? Double ?? 0.0)
                result.append(item)
            }
            
            cache = result
            return result
            
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    internal func addItem(_ item: ItemEntity) {
        if var cache = cache {
            cache.append(item)
            guard let file = FileHandle(forWritingAtPath: "products.json") else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: cache, options: .init(rawValue: 0))
                file.write(jsonData)
            } catch let error {
                print(error.localizedDescription)
            }
            // Write it to the file
            
            // Close the file
            file.closeFile()
        } else {
            _ = getItems()
            addItem(item)
        }
    }
}
