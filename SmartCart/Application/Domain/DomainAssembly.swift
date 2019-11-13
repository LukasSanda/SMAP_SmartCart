//
//  DomainAssembly.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol DomainAssembly {
    func resolve() -> DatabaseService
    func resolve() -> CartRepository
    func resolve() -> CreateNewCart
    func resolve() -> LoadLastCart
    func resolve() -> LoadAllCarts
    func resolve() -> RemoveAllCarts
    func resolve() -> RemoveCart
}
