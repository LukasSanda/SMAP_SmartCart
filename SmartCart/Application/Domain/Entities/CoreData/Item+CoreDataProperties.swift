//
//  Item+CoreDataProperties.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 07/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var category: String
    @NSManaged public var desc: String
    @NSManaged public var ean: String
    @NSManaged public var id: String
    @NSManaged public var price: Double
    @NSManaged public var size: String
    @NSManaged public var title: String
    @NSManaged public var cart: Cart

}

internal extension Item {
    func setProperties(withItemEntity entity: ItemEntity, ofAmount amount: Int) {
        self.id = Date().hashValue.description
        self.category = entity.category
        self.desc = entity.desc
        self.title = entity.title
        self.ean = entity.ean
        self.desc = entity.desc
        self.category = entity.category
        self.price = entity.price
        self.size = entity.size
        self.amount = NSDecimalNumber(value: amount)
    }
}
