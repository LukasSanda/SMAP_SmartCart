//
//  ItemEntity.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal enum ItemCategoryType: String {
    case sweets
    case drinks
    case drugstore
}

internal struct ItemEntity {
    let ean: String
    let title: String
    var desc: String?
    var price: Double?
    let category: String
    let size: Double
}
