//
//  DataError.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal enum DataError: Error {
    case noData
    case loadData
    case saveData
    
    // MARK: - Methods
    
    var localizedDescription: String {
        return handleErrorMessage()
    }
}

private extension DataError {
    func handleErrorMessage() -> String {
        switch self {
        case .noData:
            return "No available data."
        case .loadData:
            return "Error appeared during loading data."
        case .saveData:
            return "Error appeared during saving data."
        }
    }
}
