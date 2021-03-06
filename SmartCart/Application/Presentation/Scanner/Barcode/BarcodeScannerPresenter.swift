//
//  BarcodeScannerPresenter.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 15/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol BarcodeScannerPresenter {
    func checkCode(_ code: String)
}

internal protocol BarcodeScannerDelegate: class {
    func didScanItem(_ item: ItemEntity)
    func didScanUnknownItem()
}

internal class BarcodeScannerPresenterImpl: BarcodeScannerPresenter {
    
    // MARK: - Private Properties
    
    private let getKnownProducts: GetKnownProducts
    
    // MARK: - Internal Properties
    
    internal weak var delegate: BarcodeScannerDelegate?
    
    // MARK: - Initialization
    
    internal init(getKnownProducts: GetKnownProducts) {
        self.getKnownProducts = getKnownProducts
    }
    
    // MARK: - Protocol
    
    internal func checkCode(_ code: String) {
        getKnownProducts.get { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                let item = products.first { $0.ean.elementsEqual(code) }
                
                guard let foundedItem = item else {
                    self.delegate?.didScanUnknownItem()
                    return
                }
                
                self.delegate?.didScanItem(foundedItem)
            case .failure(let error):
                logger.logError(message: error.localizedDescription)
            }
        }
    }
}
