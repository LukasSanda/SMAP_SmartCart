//
//  CommitChange.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 13/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol CommitChange {
    func commit()
}

internal class CommitChangeImpl: CommitChange {

    // MARK: - Properties
    
    private let service: DatabaseService
    
    // MARK: - Initialization
    
    internal init(service: DatabaseService) {
        self.service = service
    }
    
    // MARK: - Protocol
    
    func commit() {
        service.save()
    }
}
