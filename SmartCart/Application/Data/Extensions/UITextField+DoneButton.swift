//
//  UITextField+DoneButton.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 07/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal extension UITextField {
    func addDoneToolbar() {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.tintColor = .black
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(doneButtonTapped))
        ]
        
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }

    @objc private func doneButtonTapped() { self.resignFirstResponder() }
}
