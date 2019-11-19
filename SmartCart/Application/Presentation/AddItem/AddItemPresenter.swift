//
//  AddItemPresenter.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 01/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol AddItemPresenter {
    func add(_ item: ItemEntity, ofAmount amount: Int, _ completion: @escaping (() -> Void))
}

internal protocol AddItemDelegate: class {
    func willDisplayCartContent()
}

internal class AddItemPresenterImpl: AddItemPresenter {
    
    // MARK: - Private Properties
    
    private let addItem: AddItem
    
    // MARK: - Internal Properties
    
    internal weak var delegate: AddItemDelegate?
    
    // MARK: - Initialization
    
    internal init(addItem: AddItem) {
        self.addItem = addItem
    }
    
    // MARK: - Protocol
    
    internal func add(_ item: ItemEntity, ofAmount amount: Int, _ completion: @escaping (() -> Void)) {
        addItem.add(item, ofAmount: amount) { result in
            switch result {
            case .success:
                self.delegate?.willDisplayCartContent()
                completion()
                
            case .failure(let error):
                logger.logError(message: error.localizedDescription)
            }
        }
    }
}
