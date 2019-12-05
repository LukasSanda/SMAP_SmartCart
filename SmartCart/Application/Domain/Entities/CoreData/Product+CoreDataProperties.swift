//
//  Product+CoreDataProperties.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//
//

import Foundation
import CoreData

extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var title: String
    @NSManaged public var ean: String
    @NSManaged public var desc: String
    @NSManaged public var size: Double
    @NSManaged public var price: Double
    @NSManaged public var category: String
}
