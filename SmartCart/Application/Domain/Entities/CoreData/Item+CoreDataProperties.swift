//
//  Item+CoreDataProperties.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 07/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var category: String
    @NSManaged public var desc: String
    @NSManaged public var ean: String
    @NSManaged public var price: Double
    @NSManaged public var size: Double
    @NSManaged public var title: String
    @NSManaged public var id: String
    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var cart: Cart

}
