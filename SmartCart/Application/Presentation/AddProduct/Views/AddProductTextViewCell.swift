//
//  AddProductTextViewCell.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 07/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol AddProductTextViewCellDelegate: class {
    func textViewDidEndEditing(_ textView: UITextView, inCell cell: AddProductTextViewCell)
}

internal class AddProductTextViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let textView = UITextView()
    private let placeholderLabel = UILabel()
    
    // MARK: - Internal Properties
    
    internal weak var delegate: AddProductTextViewCellDelegate?
    
    internal var placeholder: String = "" {
        didSet { setPlaceholder() }
    }
    
    // MARK: - Initialization
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITextViewDelegate
extension AddProductTextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewDidEndEditing(textView, inCell: self)
    }
}

// MARK: - Setup View Appereance
private extension AddProductTextViewCell {
    func setup() {
        textView.addDoneToolbar()
        textView.autocorrectionType = .yes
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.textView.layer.borderColor = UIColor.cellBackgroundColor.cgColor
        self.textView.layer.borderWidth = 0.5
        contentView.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(30)
        }
    }
    
    func setPlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(4)
        }
    }
}
