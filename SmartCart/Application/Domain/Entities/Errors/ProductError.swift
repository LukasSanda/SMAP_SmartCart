//
//  ProductError.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 14/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal enum ProductError: Error {
    case noFile
    case parsing
    case nativeError(_ error: Error)
    
    // MARK: - Methods
    
    var localizedDescription: String {
        return handleErrorMessage()
    }
}

private extension ProductError {
    func handleErrorMessage() -> String {
        switch self {
        case .noFile:
            return "File has not been found."
        case .parsing:
            return "Error apperead during parsing data from file."
        case .nativeError(let error):
            return error.localizedDescription
        }
    }
}
