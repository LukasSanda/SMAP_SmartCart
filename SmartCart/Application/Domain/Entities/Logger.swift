//
//  Logger.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal class Logger {
    
    // MARK: - Initialization
    
    internal init() { }
    
    // MARK: - Methods
    
    func logError(inFunction function: String = #function, inFile fileName: String = #file, message: String) {
        print(" ⛔️ Error\n File: [\(fileName)]\n Function: \(function)\n Message: \(message)\n")
    }
    
    func logWarning(inFunction function: String = #function, inFile fileName: String = #file, message: String) {
        print(" ⚠️ Warning\n File: [\(fileName)]\n Function: \(function)\n Message: \(message)\n")
    }
    
    func logInfo(inFunction function: String = #function, inFile fileName: String = #file, message: String) {
        print(" ℹ️ Info\n File: [\(fileName)]\n Function: \(function)\n Message: \(message)\n")
    }
}
