//
//  TitleScannerPresenter.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 21/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol TitleScannerPresenter {
    func didRecognizeText(_ text: String)
}

internal protocol TitleScannerDelegate: class {
    func didRecognizeItem(_ item: ItemEntity)
    func didNotRecognizeItem()
}

internal class TitleScannerPresenterImpl: TitleScannerPresenter {
    
    // MARK: - Properties
    
    private let getKnownProducts: GetKnownProducts
    
    // MARK: - Internal Properties
    
    internal weak var delegate: TitleScannerDelegate?
    
    // MARK: - Initialization
    
    internal init(getKnownProducts: GetKnownProducts) {
        self.getKnownProducts = getKnownProducts
    }
    
    // MARK: - Methods
    
    internal func didRecognizeText(_ text: String) {
        getKnownProducts.get { result in
            switch result {
            case .success(let products):
                // Trimm text
                let trimmedText = text
                    .folding(options: .diacriticInsensitive, locale: .current)
                    .replacingOccurrences(of: "\n", with: "")
                    .replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: "'", with: "")
                    .lowercased()

                products.forEach {
                    // Title and Desc without whitespaces
                    let trimmedTitle = $0.title
                        .folding(options: .diacriticInsensitive, locale: .current)
                        .replacingOccurrences(of: " ", with: "").lowercased()
                    let trimmedDesc = $0.desc
                        .folding(options: .diacriticInsensitive, locale: .current)
                        .replacingOccurrences(of: " ", with: "").lowercased()
                    
                    if trimmedText.contains(trimmedTitle) && trimmedText.contains(trimmedDesc) {
                        self.delegate?.didRecognizeItem($0)
                        return
                    }
                }
                
                self.delegate?.didNotRecognizeItem()
                
            case .failure(let error):
                logger.logError(message: error.localizedDescription)
            }
        }
    }
}
