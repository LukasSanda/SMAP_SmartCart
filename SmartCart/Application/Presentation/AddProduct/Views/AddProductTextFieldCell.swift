//
//  AddProductTextFieldCell.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 05/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal protocol AddProductTextFieldCellDelegate: class {
    func textFieldDidEndEditing(_ textfield: UITextField, inCell cell: AddProductTextFieldCell)
}

internal class AddProductTextFieldCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let descriptionLabel = UILabel()
    
    // MARK: - Internal Properties
    
    internal weak var delegate: AddProductTextFieldCellDelegate?
    
    internal var isPriceCell = false
    internal let textField = UITextField()
    internal var descriptionText: String = "" {
        didSet { descriptionLabel.text = descriptionText }
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

// MARK: - UITextFieldDelegate
extension AddProductTextFieldCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isPriceCell, !(textField.text?.isEmpty ?? true) {
            textField.text = (textField.text ?? "") + " Kč"
        }
        
        delegate?.textFieldDidEndEditing(textField, inCell: self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard isPriceCell, !(textField.text?.isEmpty ?? true), let text = textField.text else { return }
        
        let range = text.index(text.endIndex, offsetBy: -3)..<text.endIndex
        textField.text?.removeSubrange(range)
    }
}

// MARK: - Setup View Appereance
private extension AddProductTextFieldCell {
    func setup() {
        textField.delegate = self
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textField.clearButtonMode = .always
        
        descriptionLabel.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        textField.setContentHuggingPriority(.sceneSizeStayPut, for: .horizontal)
        textField.textAlignment = .right
        textField.addDoneToolbar()
        
        let stack = UIStackView
            .horizontal
            .distribute(by: .fill)
            .space(by: 16)
            .align(by: .fill)
            .stack(descriptionLabel, textField)
        
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
    }
}
