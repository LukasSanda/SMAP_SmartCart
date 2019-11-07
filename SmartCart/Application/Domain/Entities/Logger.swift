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
    
    func logError(inFunction function: String, message: String) {
        print("⛔️ Error – " + function +  ": " + message)
    }
    
    func logWarning(inFunction function: String, message: String) {
        print("⚠️ Warning – " + function +  ": " + message)
    }
    
    func logInfo(inFunction function: String, message: String) {
        print("ℹ️ Info – " + function +  ": " + message)
    }
}
