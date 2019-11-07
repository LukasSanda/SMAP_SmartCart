//
//  UIColor+Colors.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal extension UIColor {
    
    // MARK: - Constants
    
    static let primaryColor: UIColor = UIColor(red: 74, green: 165, blue: 104)
    static let secondaryColor: UIColor = .white
    
    // MARK: - Initialization
    
    convenience init(red: Int, green: Int, blue: Int, alpha: Double = 1.0) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha))
    }
}
