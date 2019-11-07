//
//  DomainAssembler.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

extension ModuleAssembler: DomainAssembly {
    func resolve() -> DatabaseService {
        if let databaseService = databaseService {
            return databaseService
        }
        
        let databaseService = DatabaseServiceImpl()
        self.databaseService = databaseService
        return databaseService
    }
    
    func resolve() -> CartRepository {
        return CartRepositoryImpl(service: resolve())
    }
    
    
}
