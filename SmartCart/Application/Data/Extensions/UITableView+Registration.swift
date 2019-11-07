//
//  UITableView+Registration.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit


internal extension UIView {
    
    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

internal extension UITableView {

    func register<T: UITableViewCell>(cell: T.Type) {
        register(cell, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(headerFooterView: T.Type) {
        register(headerFooterView, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeue<T: UITableViewCell>(cell: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
    }

    func dequeue<T: UITableViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: NSStringFromClass(T.self), for: indexPath) as! T
    }

    func dequeue<T: UITableViewHeaderFooterView>(headerFooterView: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
    }
}

