//
//  ItemEntity.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal enum ItemCategoryType: String, CaseIterable {
    case sweets
    case drinks
    case hygiene
    case dairyProducts
    case sausages
    case snacks
    
    func getTitle() -> String {
        switch self {
        case .sweets:
            return "Sweets"
        case .drinks:
            return "Drinks"
        case .hygiene:
            return "Hygiene"
        case .dairyProducts:
            return "Dairy Products"
        case .sausages:
            return "Sausages"
        case .snacks:
            return "Snacks"
        }
    }
    
    func getImage() -> UIImage {
        switch self {
        case .sweets:
            return Assets.Products.sweets
        case .drinks:
            return Assets.Products.drinks
        case .hygiene:
            return Assets.Products.hygiene
        case .dairyProducts:
            return Assets.Products.dairyProducts
        case .sausages:
            return Assets.Products.sausages
        case .snacks:
            return Assets.Products.snacks
        }
    }
}

internal struct ItemEntity: Hashable, Codable {
    var ean: String = ""
    var title: String = ""
    var desc: String = ""
    var price: Double = .nan
    var category: String = ""
    var size: String = ""
}

// MARK: - Initialization from Product
internal extension ItemEntity {
    init(product: Product) {
        ean = product.ean
        title = product.title
        desc = product.desc
        price = product.price
        category = product.category
        size = product.size
    }
}
