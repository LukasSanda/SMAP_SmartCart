//
//  DomainAssembly.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol DomainAssembly {
    // MARK: - Services
    func resolve() -> DatabaseService
    func resolve() -> ProductService
    
    // MARK: - Repositories
    func resolve() -> CartRepository
    
    // MARK: - Use-Cases Cart
    func resolve() -> CreateNewCart
    func resolve() -> LoadLastCart
    func resolve() -> LoadAllCarts
    func resolve() -> RemoveAllCarts
    func resolve() -> RemoveCart
    
    // MARK: - Use-Cases Database
    func resolve() -> CommitChange
    
    // MARK: - Use-Cases Products
    func resolve() -> GetKnownProducts
}
