//
//  ScreenAssembly.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import Foundation

internal protocol ScreenAssembly {
    func homeScreenController() -> HomeScreenController
}