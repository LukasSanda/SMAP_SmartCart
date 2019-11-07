//
//  ItemEntity.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal enum ItemCategoryType: String {
    case sweets = "Sweets"
    case drinks = "Drinks"
    case hygiene = "Hygiene"
    case dairyProducts = "Dairy Products"
    case sausages = "Sausages"
    case snacks = "Snacks"
    
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

internal struct ItemEntity {
    let ean: String
    let title: String
    var desc: String?
    var price: Double?
    let category: String
    let size: Double
}
