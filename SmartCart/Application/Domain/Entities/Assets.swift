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
    static let delete: UIImage = UIImage(named: "remove") ?? UIImage()
    static let buttonMore: UIImage = UIImage(named: "buttonMore") ?? UIImage()
    
    // MARK: - Home Screen
    
    enum CartList {
        static let shoppingCart: UIImage = UIImage(named: "shoppingCart") ?? UIImage()
    }
    
    enum ItemList {
        static let barCodeScanner: UIImage = UIImage(named: "barCodeScanner") ?? UIImage()
        static let titleScanner: UIImage = UIImage(named: "titleScanner") ?? UIImage()
        static let addToCart: UIImage = UIImage(named: "addToCart") ?? UIImage()
        static let increase: UIImage = UIImage(named: "plus") ?? UIImage()
        static let decrease: UIImage = UIImage(named: "minus") ?? UIImage()
    }
    
    enum Products {
        static let dairyProducts: UIImage = UIImage(named: "dairyProducts") ?? UIImage()
        static let sweets: UIImage = UIImage(named: "sweets") ?? UIImage()
        static let drinks: UIImage = UIImage(named: "drinks") ?? UIImage()
        static let hygiene: UIImage = UIImage(named: "hygiene") ?? UIImage()
        static let sausages: UIImage = UIImage(named: "sausages") ?? UIImage()
        static let snacks: UIImage = UIImage(named: "snacks") ?? UIImage()
    }
    
    enum AddProduct {
        static let select: UIImage = UIImage(named: "select") ?? UIImage()
    }
    
    enum Settings {
        static let mapTracking: UIImage = UIImage(named: "mapTracking") ?? UIImage()
    }
}
