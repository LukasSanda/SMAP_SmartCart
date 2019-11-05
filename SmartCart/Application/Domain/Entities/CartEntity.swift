//
//  CartEntity.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 04/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal struct CartEntity {
    let created: Date
    let title: String
    var items: [Item]
}
