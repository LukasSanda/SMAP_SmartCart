//
//  UIStackView+Maker.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal extension UIStackView {
    
    // MARK: - Static Properties
    
    static var horizontal: Maker { return Maker(axis: .horizontal) }
    static var vertical: Maker { return Maker(axis: .vertical) }
    
    class Maker {
        
        // MARK: - Properties
        
        private let stackView = UIStackView()
        
        // MARK: - Properties
        
        public var withLayoutMarginsRelativeArrangement: Maker {
            stackView.isLayoutMarginsRelativeArrangement = true
            return self
        }
        
        public var withBaselineRelativeArrangement: Maker {
            stackView.isBaselineRelativeArrangement = true
            return self
        }
        
        // MARK: - Initialization
        
        internal init(axis: NSLayoutConstraint.Axis) {
            stackView.axis = axis
        }
        
        // MARK: - Methods
        
        public func align(by alignment: UIStackView.Alignment) -> Maker {
            stackView.alignment = alignment
            return self
        }
        
        public func distribute(by distribution: UIStackView.Distribution) -> Maker {
            stackView.distribution = distribution
            return self
        }
        
        public func space(by spacing: CGFloat) -> Maker {
            stackView.spacing = spacing
            return self
        }
        
        public func inset(by insets: UIEdgeInsets) -> Maker {
            stackView.layoutMargins = insets
            return self.withLayoutMarginsRelativeArrangement
        }
        
        public func stack(_ views: UIView...) -> UIStackView {
            for view in views {
                stackView.addArrangedSubview(view)
            }
            
            return stackView
        }
    }
}
