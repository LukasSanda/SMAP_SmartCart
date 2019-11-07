//
//  NSMutableAttributedString+Formatting.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 07/11/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal extension NSMutableAttributedString {
    static func setupPrice(
        highlightedText: String,
        normalText: String,
        highlightedFontSize: CGFloat = 14,
        normalFontSize: CGFloat = 12) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(
            string: "\(normalText) \(highlightedText)",
            attributes: [
                .font: UIFont.systemFont(ofSize: normalFontSize, weight: .heavy),
                .foregroundColor: UIColor.gray])
        
        attributedString.addAttributes(
            [.foregroundColor: UIColor.black,
             .font: UIFont.systemFont(ofSize: highlightedFontSize, weight: .heavy)],
            range: NSRange(location: normalText.count + 1, length: highlightedText.count))
        
        return attributedString
    }
}
