//
//  UITextView+DoneButton.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 07/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal extension UITextView {
    func addDoneToolbar() {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    @objc private func doneButtonTapped() { self.resignFirstResponder() }
}
