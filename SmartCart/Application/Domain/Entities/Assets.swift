//
//  Assets.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal enum Assets {
    
    // MARK: - Shared
    
    static let removeBin: UIImage = UIImage(named: "removeBin") ?? UIImage()
    
    // MARK: - Home Screen
    
    enum HomeScreen {
        static let shoppingCart: UIImage = UIImage(named: "shoppingCart") ?? UIImage()
        static let delete: UIImage = UIImage(named: "remove") ?? UIImage()
    }
}
